class AccountSetting < ActiveRecord::Base
  
  BLOCK_LIST = ['www']
  belongs_to :account

  validates :blog_alias, uniqueness: true, length: { minimum: 3 }
  validate :validate_block_list

  def validate_block_list
    errors.add(:blog_alias, 'is not allowed.') if BLOCK_LIST.include?(self.blog_alias.downcase)
  end
end
