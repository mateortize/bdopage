class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :restrict_access
  before_filter :load_current_author

  def load_current_author
    setting = AccountSetting.where(blog_alias: request.subdomain).first
    account = setting.account unless setting.blank?
    @current_author = Account.first
    return @current_author

    @current_author = account if request.subdomain.present?

    return @current_author
  end

  def current_guest
    current_account
  end

  def current_author
    @current_author
  end

  private

  def restrict_access
    if request.subdomain.present? && request.subdomain != "www"
      raise ActionController::RoutingError.new('Not Found') if AccountSetting.where(blog_alias: request.subdomain).blank?
    end
  end

end
