require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:test_plan) do
    OpenStruct.new({
      name: 'TEST',
      price_cents: 100,
      post_limit: 10
    })
  end

  subject do
    obj = create :order
    allow(obj).to receive(:plan) { test_plan }
    obj
  end

  it 'subject' do
    pp subject
    expect(subject).to be_a described_class
    expect(subject.plan[:name]).to eq test_plan[:name]
  end

  it '#status' do
    expect(subject).to be_created
    subject.active!
    subject.reload
    expect(subject.status).to eq 'active'
    expect(subject).to be_active
  end

  it '#billing_address' do
    pp subject.billing_address
    expect(subject.billing_address).to be_a Address
  end

  it '#credit_card' do
    credit_card = subject.send :credit_card
    pp credit_card
    expect(credit_card).to be_valid
  end

  it '#purchase_options' do
    opts = subject.send :purchase_options
    pp opts
    expect(opts).to be_present
  end

  describe "#calculate_prices" do
    it "calculate subtotal, tax and total cents" do
      subject.calculate_prices

      expect(subject.subtotal_cents).to eq 100
      expect(subject.tax_cents).to eq Rails.application.secrets[:tax_percentage].to_f
      expect(subject.total_cents).to eq(100 + Rails.application.secrets[:tax_percentage].to_f)
    end
  end

  describe "#create_payment!" do
    it "will create inatec payment" do
      expect(subject).to be_created

      subject.create_payment!
      subject.reload
      expect(subject).to be_active
      expect(subject.card_brand).to eq 'visa'
      expect(subject.last_4_digits).to eq 'XXXX-XXXX-XXXX-0147'
    end

    it "will be failed with wrong card info" do
      order = build(:order, ip: '127.0.0.1', number: '4149011500000148', year: 2014, month: 12, verification_value: 147)
      expect {
        order.create_payment!
      }.to raise_error /validation failed/
      expect(order).to be_failed
    end
  end

  describe "#create_recurring_payment!" do
    before :each do
      subject.create_payment!
    end

    it "will create recurring payment with transaction_id" do
      subject.create_recurring_payment!
      expect(subject).to be_active
    end

    it "will be failed with wrong transaction_id" do
      subject.transaction_id = 'wrong_transaction_id'
      expect {
        subject.create_recurring_payment!
      }.to raise_error /transaction failed/
      expect(subject).to be_failed
    end
  end

  describe "#cancelled!" do
    it "will cancel order" do
      subject.cancelled!
      subject.reload
      expect(subject).to be_cancelled
    end
  end

  it '#check_credit_card_validation' do
    order = build(:order, ip: '127.0.0.1', number: '4149011500000148', year: 2014, month: 12, verification_value: 147)
    expect(order.check_credit_card_validation).to eq false
    pp order.errors.to_hash
  end

  it 'billing_address_attributes' do
    attrs = attributes_for :address
    params = { "plan_type" => "pro", "number" => "4149011500000147", "year" => "2014", "month" => "12", "verification_value" => "147",
               "billing_address_attributes" => attrs }
    order = Order.new(params)
    order.account = create :account
    order.payment_method = 'inatec'
    order.calculate_prices
    order.save!
    pp order
    pp order.billing_address
    expect(order).to be_persisted
  end

  it '.generate_pdf' do
    Order.generate_pdf(subject.id)
    subject.reload
    expect(subject.invoice_file).to be_present
  end

  it '#tax_percentage' do
    subject.calculate_prices
    pp subject
    expect(subject.tax_percentage).to eq Rails.application.secrets[:tax_percentage].to_f
  end

  it '#invoice_filename' do
    pp subject.invoice_filename
    expect(subject.invoice_filename).to match /VP7.+pdf/
  end

  it '#full_name' do
    expect(subject.full_name).to be_present
  end
end
