class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  #disabled :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_commontator
  acts_as_followable
  acts_as_follower
  
  has_many :posts
  has_many :videos
  has_many :authentications, dependent: :destroy

  has_one :setting, class_name: 'AccountSetting'
  has_one :profile, class_name: 'AccountProfile'

  after_create :generate_setting
  after_create :generate_profile


  def full_name
    return "#{self.profile.first_name} #{self.profile.last_name}" if self.profile.present?
    "Unknown"
  end

  def blog_alias
    self.setting.blog_alias.strip
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

      profile = account.profile
      profile.first_name = auth.info.first_name
      profile.last_name = auth.info.last_name
      profile.save
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

  def generate_setting
    self.create_setting(blog_alias: Time.now.to_i, blog_enabled: false)
  end

  def generate_profile
    self.create_profile()
  end
end
