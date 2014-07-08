class SessionsController < Devise::SessionsController
  before_filter :restrict_access_on_none_www
  def restrict_access_on_none_www
    if request.subdomain.present? && request.subdomain != "www"
      redirect_to edit_admin_setting_url(host: "www.#{request.domain}")
    end
  end
end
