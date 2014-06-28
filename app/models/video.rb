class Video < ActiveRecord::Base
  belongs_to :post
  belongs_to :account, counter_cache: true

  has_many :encodings, class_name: 'VideoEncoding', foreign_key: 'video_id'

  validates_presence_of :panda_video_id
  scope :encoded, -> { where(encoded: true) }

  after_destroy :delete_panda_video

  def panda_video
    @panda_video ||= Panda::Video.find(self.panda_video_id)
  end

  def panda_encodings
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

  def create_video_encoding(encoding)
    self.encodings.create_from_panda_encoding(encoding)
    self.width = encoding.width
    self.height = encoding.height
    self.file_size = encoding.file_size
    self.screenshot = encoding.screenshots.first
    self.encoded = true
    self.save
  end

  def refresh
    video = self.panda_video
    unless video.status == 'fail'
      encodings = video.encodings
      unless encodings.blank?
        encodings.each do |encoding|
          if encoding.status == "success"
            self.create_video_encoding(encoding)
          end
        end
      end
    end
  end

  private

  def delete_panda_video
    panda_video.delete
  end

end
