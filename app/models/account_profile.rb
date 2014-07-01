class AccountProfile < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  belongs_to :account

  validates :account_id, uniqueness: true

  def profile_image
    return avatar_url unless avatar_url.blank?
    ActionController::Base.helpers.asset_path("nouserimage.jpg", :digest => false)
  end
end
