class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_commontator
  
  has_many :posts
  has_many :videos

  has_one :setting, class_name: 'AccountSetting'
  has_one :profile, class_name: 'AccountProfile'

  after_create :create_setting


  def full_name
    return "#{self.profile.first_name} #{self.profile.last_name}" if self.profile.present?
    "Unknown"
  end

  private

  def create_setting
    self.setting = AccountSetting.create(blog_alias: Time.now.to_i, blog_enabled: false)
    self.save
  end
end
