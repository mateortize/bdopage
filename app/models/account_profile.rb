class AccountProfile < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  belongs_to :account

  serialize :private_fields

  validates :account_id, uniqueness: true
  validate :avatar_file_size

  def avatar_file_size
    unless !avatar.blank?
      unless avatar.file.blank?
        if avatar.file.size.to_f/(1000*1000) > 2
          errors.add(:file, "You cannot upload a file greater than 2MB")
        end
      end
    end
  end

  def profile_image
    return avatar_url unless avatar_url.blank?
    ActionController::Base.helpers.asset_path("nouserimage.jpg", :digest => false)
  end
end
