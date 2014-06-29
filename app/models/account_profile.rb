class AccountProfile < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  belongs_to :account

  validates :account_id, uniqueness: true
end
