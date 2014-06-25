class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_commontator
  
  has_many :posts
  has_many :videos
  has_many :authentications, dependent: :destroy

  has_one :setting, class_name: 'AccountSetting'
  has_one :profile, class_name: 'AccountProfile'

  after_create :create_setting


  def full_name
    return "#{self.profile.first_name} #{self.profile.last_name}" if self.profile.present?
    "Unknown"
  end

  def self.from_omniauth(auth)
    Authentication.where(auth.slice("provider", "uid")).first.try(:account) || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    unless account = Account.find_by_email(auth["info"]["email"])
      password = Devise.friendly_token[0,20]
      account = Account.create(
        email:                  auth.info.email,
        password:               password,
        password_confirmation:  password,
      )

      profile = AccountProfile.create(
        first_name:             auth.info.first_name,
        last_name:              auth.info.last_name
      )

      account.profile = profile
      account.save
    end

    account.authentications.build(
      provider: auth["provider"],
      uid:  auth["uid"],
      token: auth["credentials"]["token"]
    )
    account.save
    account
  end


  private

  def create_setting
    self.setting = AccountSetting.create(blog_alias: Time.now.to_i, blog_enabled: false)
    self.save
  end
end
