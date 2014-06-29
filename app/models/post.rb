class Post < ActiveRecord::Base
  include AutoHtml
  include Bootsy::Container
  acts_as_commontable
  

  has_one :video
  belongs_to :account

  scope :published, -> { where(published: true) }
  
  validates :title, presence: true
  validates :account_id, presence: true

  after_save :send_new_post_notification

  auto_html_for :video_url do
    html_escape
    image
    youtube(:width => '100%', :height => nil, :autoplay => false)
    vimeo(:width => '100%', :height => nil, :autoplay => false)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

  def the_excerpt
    return self.excerpt if self.excerpt.present?
    self.content.html_safe.truncate(100)
  end

  def published?
    unless self.video.blank?
      return self.video.encoded?
    else
      return !self.video_url.blank?
    end
  end

  def has_video?
    self.video.present? or self.video_url.present?
  end

  def send_new_post_notification
    if self.published_changed?
      self.account.followers.each do |account|
        Notifier.delay.send_new_post_to_follower(self.id, account.id)
      end
    end
  end

end
