class VideoEncoding < ActiveRecord::Base
  belongs_to :video

  validates :profile_name, uniqueness: true, presence: true

  def self.create_from_panda_encoding(encoding)
    self.create(
      panda_video_id: encoding.video_id
      profile_name: encoding.profile_name,
      status: encoding.status,
      width: encoding.width,
      height: encoding.height,
      url: encoding.url,
      file_size: encoding.file_size
      )
  end
end
