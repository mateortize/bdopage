class AccountsController < ApplicationController
  skip_before_action :authenticate_account!, only: [:show, :videos]
  before_filter :load_account

  layout 'bgwhite'

  def show
    set_tab :profile
    @profile = @account.profile
  end

  def follow
    current_account.follow(@account)
    current_account.reload
    redirect_to account_path(@account)
  end

  def videos
    set_tab :videos
    @posts = @account.posts.published.order("created_at desc").page(params[:page]).per(12)
  end

  def unfollow
    current_account.stop_following(@account) if current_account.following?(@account)
    current_account.reload
    redirect_to account_path(@account)
  end

  private
    def load_account
      @account = Account.find(params[:id])
    end
  
end
