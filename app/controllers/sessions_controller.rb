class SessionsController < ApplicationController
  skip_before_action :authenticate_account!

  def new
    render layout: false
  end
  
end
