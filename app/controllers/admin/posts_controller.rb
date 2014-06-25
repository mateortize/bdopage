class Admin::PostsController < Admin::BaseController
  
  def index
    @posts = current_account.posts.order("created_at desc").page(params[:page]).per(5)
  end

  def show
    @posts = current_account.posts
  end
  
  def edit
    @post = current_account.posts.find(params[:id])
  end

  def new
    @post = Post.new
    @post.account = current_account
  end

  def update
    @post = current_account.posts.find(params[:id])
    @post.update_attributes(post_params)
    redirect_to admin_posts_path
  end

  def create
    @post = Post.new(post_params)
    @post.account = current_account
    @post.save
    redirect_to admin_posts_path
  end

  def available_videos
    @videos = current_account.videos.page(params[:page]).per(12)
    render layout: 'clean'
  end

  private

    def post_params
      params.require(:post).permit(:title,:content, :excerpt, :video_id)
    end
end
