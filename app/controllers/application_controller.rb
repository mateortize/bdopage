class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_account!
  
  before_filter :restrict_access
  before_filter :load_current_author

  def load_current_author
    @current_author = @account_setting.try(:account)
    return @current_author
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
      @account_setting = AccountSetting.where(blog_alias: request.subdomain).first
      raise ActionController::RoutingError.new('Not Found') if @account_setting.blank?
    end
  end

end
