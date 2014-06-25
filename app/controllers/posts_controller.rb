class PostsController < ApplicationController
  before_filter :load_post, only: [:show, :comment]
  
  def index
  end

  def show
  end

  private

  def load_post
    @post = Post.find(params[:id])
  end
  
end
