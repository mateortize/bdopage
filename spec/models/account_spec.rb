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
      expect(subject.current_plan).to eq Order.free_plan
    end

    it 'inactive' do
      s1 = create :order, account: subject, status: :inactive
      expect(subject.current_plan).to eq Order.free_plan
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
end
