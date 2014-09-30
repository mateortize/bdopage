class OmniauthController < ApplicationController
  skip_before_action :authenticate_account!
  skip_before_action :verify_authenticity_token

  def create
    @account = Account.from_omniauth(env['omniauth.auth'])

    if @account.persisted?
      if session[:referrer_code].present?
        @account.apply_referrer_code!(session[:referrer_code])
        session[:referrer_code] = nil
      end
    end

    sign_in @account
    redirect_to posts_path
  end
end
