class Accounts::BaseController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_account!


  before_filter :restrict_access

  layout 'backend'

  private

  def restrict_access
    if request.subdomain.present? && request.subdomain != "www"
      raise ActionController::RoutingError.new('Not Found') unless current_user.setting.blog_alias == request.subdomain
    end
  end

end
