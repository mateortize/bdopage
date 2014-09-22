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

  def validate_block_list
    errors.add(:blog_alias, 'is not allowed.') if BLOCK_LIST.include?(self.blog_alias.to_s.downcase)
  end

  def show_blog_logo?
    blog_logo? && account.can_upload_blog_logo?
  end

end
