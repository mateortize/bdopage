class ProfilesController < ApplicationController
  skip_before_action :authenticate_account!
  
  def index
    @profile = @current_author.account_profile
    render :show
  end
  
end
