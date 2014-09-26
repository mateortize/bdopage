class AccountSetting < ActiveRecord::Base
  mount_uploader :blog_logo, LogoUploader

  BLOCK_LIST = ['www']
  belongs_to :account

  validates :account_id, uniqueness: true
  validates :blog_alias, uniqueness: true, length: { minimum: 3 }
  validate :validate_block_list
  validates_format_of     :blog_alias,
                          :with => /\A[a-z0-9\-]*?\z/,
                          :message => 'accepts only lower case letters, numbers'
  validate :validate_blog_alias_change

  def validate_block_list
    errors.add(:blog_alias, 'is not allowed.') if BLOCK_LIST.include?(self.blog_alias.to_s.downcase)
  end

  def show_blog_logo?
    blog_logo? && account.can_upload_blog_logo?
  end

  def validate_blog_alias_change
    errors.add(:blog_alias, "can change only 1 time a month.") if !self.blog_alias_changed_at.blank? and 1.month.ago < self.blog_alias_changed_at
  end

  def update_blog_alias_changed_at
    self.blog_alias_changed_at = Time.now
    self.save(validate: false)
  end

end
