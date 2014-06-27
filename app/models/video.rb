class Video < ActiveRecord::Base
  has_many :posts
  belongs_to :account, counter_cache: true
  validates_presence_of :panda_video_id
  scope :encoded, -> { where(encoded: true) }

  before_update :update_video_profile

  def panda_video
    @panda_video ||= Panda::Video.find(self.panda_video_id)
  end

  def encodings
    @encodings ||= self.panda_video.encodings
  end

  def screenshots
    if self.panda_video_id
      @screenshots ||= self.encodings.first.screenshots
    else
      []
    end
  end

  def humanized_title
    return 'Untitled' if self.title.blank?
    self.title
  end

  def update_video_profile!(encoding)
    self.profile = encoding.profile_name
    self.height = encoding.height
    self.width = encoding.width
    self.encoded = true
    self.url = encoding.url
    self.file_size = self.panda_video.file_size
    self.screenshot ||= encoding.screenshots.first
    self.save
  end

  private

  def update_video_profile
    if self.profile_changed?
      encoding = self.encodings[self.profile]
      if !encoding.blank?
        self.height ||= encoding.height
        self.width ||= encoding.width
        self.encoded = true
        self.url = encoding.url
        self.file_size ||= self.panda_video.file_size
      end
    end
  end

end
