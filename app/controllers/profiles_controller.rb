class ProfilesController < ApplicationController
  skip_before_action :authenticate_account!
  

  def show
    @account = @current_author
    @profile = @current_author.profile
  end
  
end
