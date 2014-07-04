class AccountSetting < ActiveRecord::Base
  
  BLOCK_LIST = ['www']
  belongs_to :account

  validates :account_id, uniqueness: true
  validates :blog_alias, uniqueness: true, length: { minimum: 3 }
  validate :validate_block_list
  validates_format_of     :blog_alias,
                          :with => /\A[a-zA-Z0-9\-]*?\z/,
                          :message => 'accepts only letters, numbers'

  def validate_block_list
    errors.add(:blog_alias, 'is not allowed.') if BLOCK_LIST.include?(self.blog_alias.to_s.downcase)
  end
end
