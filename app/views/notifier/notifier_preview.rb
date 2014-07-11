class NotifierPreview < ActionMailer::Preview
  def send_new_post_to_follower
    Notifier.send_new_post_to_follower(Post.first.id, Account.first.id)
  end
end