require 'rails_helper'

RSpec.describe Account, type: :model do
  subject do
    create :account
  end

  it 'subject' do
    pp subject
    expect(subject).to be_a described_class
  end

  it '#profile' do
    pp subject.profile
    expect(subject.profile).to be_a AccountProfile
  end

  describe '#current_plan' do
    it 'free' do
      expect(subject.current_plan).to eq Plan.free_plan
    end

    it 'inactive' do
      s1 = create :order, account: subject, status: :inactive
      expect(subject.current_plan).to eq Plan.free_plan
    end

    it 'active' do
      s1 = create :order, account: subject, status: :active
      expect(subject.current_plan).to eq s1.plan
    end
  end

  it '#apply_referrer_code!' do
    subject.bonofa_partner_account_id = nil
    subject.apply_referrer_code! 'bonofa'
    expect(subject.bonofa_partner_account_id).to eq 1
  end

  describe '.from_omniauth' do
    let(:info) { OpenStruct.new baio_package: Plan::BAIO_FOR_EXPERT.first }
    let(:auth) { OpenStruct.new provider: 'bonofa', uid: '1', info: info }

    before(:each) {
      subject.authentications.create! provider: 'bonofa', uid:  '1', token: '111'
    }

    it 'baio partner get expert plan' do
      a1 = Account.from_omniauth(auth) # upgrade
      expect(subject).to eq a1
      expect(subject.current_plan).to eq Plan.expert_plan

      info.baio_package = 'bad'
      Account.from_omniauth(auth) # downgrade
      expect(subject.current_plan).to eq Plan.free_plan
    end

    it 'not baio partner downgrade' do
      subject.orders.create! plan_type: 'pro', status: :active, payment_method: 'inatec', expired_at: 1.years.since
      expect(subject.current_plan).to eq Plan.pro_plan

      Order.create_baio_order(subject)
      expect(subject.current_plan).to eq Plan.expert_plan

      info.baio_package = 'bad'
      Account.from_omniauth(auth) # downgrade
      expect(subject.current_plan).to eq Plan.pro_plan
    end
  end
end
