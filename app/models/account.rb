class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_commontator
  
  has_many :posts
  has_many :videos
  has_one :account_setting
  has_one :account_profile

  def full_name
    return "#{self.account_profile.first_name} #{self.account_profile.last_name}" if self.account_profile.present?
    "Unknown"
  end
end
