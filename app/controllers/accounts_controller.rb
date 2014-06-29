class AccountsController < ApplicationController
  skip_before_action :authenticate_account!, only: [:show]
  
  def show
    @account = Account.find(params[:id])
  end

  def follow
    @account = Account.find(params[:id])
    current_account.follow
  end
  
end
