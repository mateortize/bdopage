class AccountProfile < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  belongs_to :account

  validates :account_id, uniqueness: true
  validate :avatar_file_size

<<<<<<< HEAD
  def avatar_file_size
    if !avatar.blank?
=======
  def avatar_size
    unless avatar.file.blank?
>>>>>>> 5766979d6b096b045decea8056262c04f189b2d2
      if avatar.file.size.to_f/(1000*1000) > 2
        errors.add(:file, "You cannot upload a file greater than 2MB")
      end
    end
  end

  def profile_image
    return avatar_url unless avatar_url.blank?
    ActionController::Base.helpers.asset_path("nouserimage.jpg", :digest => false)
  end
end
