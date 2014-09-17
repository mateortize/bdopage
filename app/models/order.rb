require 'active_merchant/billing/rails'

class Order < ActiveRecord::Base
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
    }),
    pro: OpenStruct.new({
      active: true,
      upgrade_rating: 10,
      name: 'PRO',
      price_cents: 1000,
      post_limit: -1,
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
    calculate_prices unless total_cents

    response = ::INATEC_GATEWAY.authorize_with_recurring(total_cents, credit_card, purchase_options)
    process_response(response)

    self.card_brand = credit_card.brand
    self.last_4_digits = credit_card.display_number
    save

    response.success?
  end

  def create_recurring_payment!
    response = ::INATEC_GATEWAY.charge_recurring(total_cents, transaction_id, purchase_options)
    process_response(response)
    save

    response.success?
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
      active!
    else
      failed!
      errors.add :base, response.message
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

  def inactive_others
    account.orders.active.update_all(status: Order.statuses[:inactive])
  end
end
