class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :video

  belongs_to :account

  def the_excerpt
    return self.excerpt if self.excerpt.present?
    self.content.html_safe.truncate(100)
  end
end
