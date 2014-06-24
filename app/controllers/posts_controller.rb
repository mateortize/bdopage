class PostsController < ApplicationController
  before_filter :load_post, only: [:show, :comment]
  
  def index
    @posts = current_author.posts.order("created_at").page(params[:page]).per(5)
  end

  def show
  end

  private

  def load_post
    @post = current_author.posts.find(params[:id])
  end
  
end
