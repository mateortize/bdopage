require 'timeout'
class Post < ActiveRecord::Base
  include AutoHtml
  include Bootsy::Container
  acts_as_commontable
  
  #post status: published, draft

  has_one :video, dependent: :destroy
  belongs_to :account

  scope :published, -> { where(published: true) }
  
  validates :title, presence: true
  validates :account_id, presence: true
  validate :validate_video_ability, on: :update

  after_save :send_new_post_notification

  auto_html_for :video_url do
    html_escape
    image
    youtube(:width => '100%', :height => nil, :autoplay => false)
    vimeo(:width => '100%', :height => nil, :autoplay => false)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

  def validate_video_ability
    errors.add(:video_url, 'Please input video url or upload your video.') unless self.has_video?
    if self.has_embeded_video?
      errors.add(:video_url, 'Please input correct youtube or vimeo url.') if embeded_video.blank? or !embeded_video.available?
    end
  end

  def publish!
    self.status = 'published'
    self.published = true
    self.save
  end

  def unpublish!
    self.status = 'private'
    self.published = false
    self.save
  end

  def save_draft!
    self.status = 'draft'
    self.published = false
    self.save(validate: false)
  end

  def the_excerpt
    return self.excerpt if self.excerpt.present?
    self.content.html_safe.truncate(100)
  end

  def embeded_video
    if has_embeded_video?
      begin
        return VideoInfo.new(self.video_url)
      rescue
        return nil
      end
    end

    return nil
  end

  def embeded_video_thumbnail_small
    begin
      Timeout::timeout(3) do
        return embeded_video.thumbnail_small if !embeded_video.blank?
      end
    rescue Timeout::Error
      return nil
    end
  end

  def has_video?
    self.video.present? or self.video_url.present?
  end

  def has_panda_video?
    return false if has_video?
    return self.video.panda_video_id.present?
  end

  def has_embeded_video?
    self.video_url.present?
  end

  # send email notification to followers
  def send_new_post_notification
    if self.published_changed?
      self.account.followers.each do |account|
        Notifier.delay.send_new_post_to_follower(self.id, account.id)
      end
    end
  end

end
