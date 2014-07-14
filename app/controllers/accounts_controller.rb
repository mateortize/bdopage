class AccountsController < ApplicationController
  skip_before_action :authenticate_account!, only: [:show, :videos]
  before_filter :load_account

  layout 'bgwhite'

  def show
    set_tab :profile
    @profile = @account.profile
  end

  def follow
    me = Account.find(current_account.id)
    me.follow(@account)
    redirect_to :back
  end

  def videos
    set_tab :videos
    @posts = @account.posts.published.order("created_at desc").page(params[:page]).per(12)
  end

  def unfollow
    me = Account.find(current_account.id)
    me.stop_following(@account) if me.following?(@account)
    redirect_to :back
  end

  private
    def load_account
      @account = Account.find(params[:id])
    end
  
end
