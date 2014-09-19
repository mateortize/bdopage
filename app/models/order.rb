require 'active_merchant/billing/rails'

class Order < ActiveRecord::Base
  include TokenGenerator

  TAX_PERCENTAGE = 8.0
  CURRENCY_CODE = 'EUR'
  DURATION = 12 # months

  PLANS = {
    free: OpenStruct.new({
      active: false,
      upgrade_rating: 0,
      name: 'FREE',
      price_cents: 0,
      post_limit: 5,
      post_category: false
    }),
    pro: OpenStruct.new({
      active: true,
      upgrade_rating: 10,
      name: 'PRO',
      price_cents: 1000,
      post_limit: nil, # Can post unlimited videos
      post_category: true # Can put videos in the category "My successes"
    }),
    # expert
  }.with_indifferent_access.freeze

  belongs_to :account
  has_one :billing_address, class_name: 'Address', as: :addressable, inverse_of: :addressable, dependent: :destroy
  accepts_nested_attributes_for :billing_address

  scope :inatec, -> { where(payment_method: 'inatec') }

  enum status: { created: 0, active: 1, inactive: 2, cancelled: 3, failed: 4 }
  serialize :info, Hash
  mount_uploader :invoice_file, InvoiceUploader
  attr_accessor :number, :year, :month, :verification_value, :ip

  monetize :subtotal_cents
  monetize :tax_cents
  monetize :total_cents

  validates :account, :plan, :plan_type, :status, :payment_method, presence: true

  before_create :inactive_others

  def self.free_plan
    PLANS[:free]
  end

  def plan
    PLANS[plan_type]
  end

  def calculate_prices
    self.subtotal_cents = plan[:price_cents]

    self.total_cents = ((subtotal_cents / 100.0) * TAX_PERCENTAGE) + subtotal_cents
    self.tax_cents = total_cents - subtotal_cents
  end

  def create_payment!
    self.payment_method = 'inatec'
    self.card_brand = credit_card.brand
    self.last_4_digits = credit_card.display_number
    calculate_prices unless total_cents

    unless valid? && check_credit_card_validation
      self.status = :failed
      raise 'Order validation failed'
    end

    response = ::INATEC_GATEWAY.authorize_with_recurring(total_cents, credit_card, purchase_options)
    process_response(response)

    generate_invoice_and_send_mail
  end

  def create_recurring_payment!
    response = ::INATEC_GATEWAY.charge_recurring(total_cents, transaction_id, purchase_options)
    process_response(response)

    generate_invoice_and_send_mail
  end

  def self.generate_pdf(order_id)
    order = Order.find(order_id)
    return if order.payment_method == 'baio'

    FileUtils.mkpath("tmp/orders")
    tmp_path = "tmp/orders/invoice_#{order.id}.pdf"

    pdf_content = PdfCreator.render_invoice(order)
    File.open(tmp_path, 'wb'){|f| f.write pdf_content }

    order.invoice_file = File.open(tmp_path)
    order.save
    FileUtils.rm(tmp_path)

    AccountMailer.payment_success_mail(order.id).deliver
  end

  def check_credit_card_validation
    success = true

    unless credit_card.valid?
      success = false

      credit_card.errors.each do |k,v|
        unless v.blank?
          errors.add(k, v.first)
          errors.add(:number, 'is invalid') if k == 'brand'
        end
      end
    end

    success
  end

  private

  def process_response(response)
    if response.success?
      self.info = response.params
      self.transaction_id = response.params["transid"].first if self.transaction_id.blank?
      self.expired_at = DURATION.months.since
      self.status = :active
      save!
    else
      self.status = :failed
      errors.add :base, response.message
      raise "Payment transaction failed: #{response.message}"
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      first_name:         account.profile.first_name,
      last_name:          account.profile.last_name,
      month:              month,
      year:               year,
      verification_value: verification_value,
      number:             number
    )
  end

  def purchase_options
    {
      order_id:     "#{Time.now.to_i}-#{SecureRandom.random_number(1_000_000_000)}",
      ip:           ip,
      first_name:   account.profile.first_name,
      last_name:    account.profile.last_name,
      description:  'Videopage7 plan purchase',
      email:        account.email,
      currency:     CURRENCY_CODE,
      address: {
        zip:        billing_address.postal_code,
        street:     billing_address.address_1,
        city:       billing_address.city,
        country:    billing_address.billing_country
      }
    }
  end

  def generate_invoice_and_send_mail
    Order.delay.generate_pdf(self.id)
  end

  def inactive_others
    account.orders.active.update_all(status: Order.statuses[:inactive])
  end
end
