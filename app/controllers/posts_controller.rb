class PostsController < ApplicationController
  skip_before_action :authenticate_account!, only: [:index, :show]
  before_filter :load_post, only: [:show, :edit]
  
  def index
    if @current_author.blank?
      @posts = Post.all.order("created_at desc").page(params[:page]).per(12)
    else
      @posts = current_author.posts.order("created_at desc").page(params[:page]).per(12)
    end
  end

  def new
    @post = Post.new
  end

  def show
  end

  def update
    @post = current_account.posts.find(params[:id])
    if @post.update_attributes(post_params)
      unless @post.video.blank?
        redirect_to post_path(@post)
      else
        redirect_to new_post_video_path(@post)
      end
    else
      render :edit
    end
  end

  def create
    @post = Post.new(post_params)
    @post.account = current_account
    if @post.save
      redirect_to new_post_video_path(@post)
    else
      render :edit
    end
    
  end

  private

  def load_post
    @post = Post.find(params[:id])
  end
  
  private

    def post_params
      params.require(:post).permit(:title,:content, :excerpt, :video_id)
    end
end
