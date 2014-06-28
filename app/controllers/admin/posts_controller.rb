class Admin::PostsController < Admin::BaseController

  before_filter :load_post, only: [:show, :edit]
  
  set_tab :post

  def index
    @posts = current_account.posts.order("created_at desc").page(params[:page]).per(5)
  end

  def new
    @post = Post.new
    @post.account = current_account
  end

  def show
  end

  def update
    @post = current_account.posts.find(params[:id])
    if @post.update_attributes(post_params)
        unless @post.has_video?
          redirect_to new_admin_post_video_path(@post)
        end
    end
    render :edit
  end

  def create
    @post = Post.new(post_params)
    @post.account = current_account
    if @post.save
      redirect_to new_admin_post_video_path(@post)
    else
      render :edit
    end
  end

  private

  def load_post
    @post = current_account.posts.find(params[:id])
  end
  
  private

    def post_params
      params.require(:post).permit(:title,:content, :excerpt, :video_url)
    end
end
