class OmniauthController < ApplicationController
  skip_before_action :authenticate_account!
  skip_before_action :verify_authenticity_token

  def create
    @account = Account.from_omniauth(env['omniauth.auth'])
    flash[:success] = "Signed in."

    sign_in @account
    redirect_to root_path
  end
end
