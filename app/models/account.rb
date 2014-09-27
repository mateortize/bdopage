class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_commontator
  acts_as_followable
  acts_as_follower

  
  has_many :posts, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_many :orders, dependent: :destroy

  has_one :setting, class_name: 'AccountSetting', dependent: :destroy
  has_one :profile, class_name: 'AccountProfile', dependent: :destroy

  has_many :pages, dependent: :destroy

  after_create :generate_setting
  after_create :generate_profile
  after_create :generate_default_pages

  def full_name
    return "#{self.profile.first_name} #{self.profile.last_name}" if self.profile.present?
    "Unknown"
  end

  def current_plan
    order = orders.active.first
    if order
      order.plan
    else
      Order.free_plan
    end
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

  def posts_for(status)
    if status == 'all'
      @posts = self.posts
    elsif status == 'trash'
      @posts = self.posts.only_deleted
    else
      @posts = self.posts.where(status: status)
    end
  end

  def generate_setting
    self.create_setting(blog_alias: Time.now.to_i, blog_enabled: false)
  end

  def generate_profile
    self.create_profile()
  end

  def generate_default_pages
    self.pages.create(slug: 'imprint', title: 'Imprint', content: '')
  end

  def check_upgrade_plan!(new_plan)
    unless new_plan.try :active
      raise 'Bad or inactive plan'
    end

    if new_plan == current_plan
      raise 'Plan already activated'
    end

    unless new_plan.upgrade_rating > current_plan.upgrade_rating
      raise "Can't upgrade to plan"
    end
  end

  def can_create_post?
    current_plan.post_limit.nil? || current_plan.post_limit > posts.count
  end

  def can_use_post_category?
    !!current_plan.post_category
  end

  def can_upload_blog_logo?
    !!current_plan.blog_logo
  end
end
