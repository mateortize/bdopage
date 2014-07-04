class AccountsController < ApplicationController
  skip_before_action :authenticate_account!, only: [:show]
  before_filter :load_account, only:[:show, :follow, :unfollow]
  
  def show
    @profile = @account.profile
  end

  def follow
    current_account.follow(@account)
    redirect_to :back
  end

  def unfollow
    current_account.stop_following(@account) if current_account.following?(@account)
    redirect_to :back
  end

  private
    def load_account
      @account = Account.find(params[:id])
    end
  
end
