class AccountsController < ApplicationController
  skip_before_action :authenticate_account!, only: [:show]
  
  def show
    @account = Account.find(params[:id])
    @profile = @account.profile
  end

  def follow
    @account = Account.find(params[:id])
    current_account.follow(@account)

    flash[:success] = "You followed him."
    redirect_to :back
  end
  
end
