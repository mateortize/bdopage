class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_account!
  
  before_filter :restrict_access
  before_filter :load_current_author
  before_filter :load_posts
  
  def load_posts
    if @current_author.blank?
      @posts = Post.all.order("created_at desc").page(params[:page]).per(5)
    else
      @posts = current_author.posts.order("created_at desc").page(params[:page]).per(5)
    end
  end

  def load_current_author
    setting = AccountSetting.where(blog_alias: request.subdomain).first
    @current_author = setting.account unless setting.blank?
    return @current_author
  end

  def current_guest
    current_account
  end

  def current_author
    @current_author
  end

  def current_user
    current_account
  end

  private

  def restrict_access
    if request.subdomain.present? && request.subdomain != "www"
      raise ActionController::RoutingError.new('Not Found') if AccountSetting.where(blog_alias: request.subdomain).blank?
    end
  end

end
