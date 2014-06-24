class ProfilesController < ApplicationController
  
  def index
    @profile = current_author.account_profile
    render :show
  end
  
end
