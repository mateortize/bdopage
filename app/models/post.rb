class Post < ActiveRecord::Base
  acts_as_commontable
  
  belongs_to :video
  belongs_to :account

  validates :title, presence: true
  validates :account_id, presence: true

  def the_excerpt
    return self.excerpt if self.excerpt.present?
    self.content.html_safe.truncate(100)
  end
end
