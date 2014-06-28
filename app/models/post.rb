class Post < ActiveRecord::Base
  include AutoHtml
  acts_as_commontable
  
  has_one :video
  belongs_to :account
  
  validates :title, presence: true
  validates :account_id, presence: true

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
end
