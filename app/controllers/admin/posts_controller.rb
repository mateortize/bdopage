class Admin::PostsController < Admin::BaseController

  before_filter :load_post, only: [:show, :edit, :destroy]
  
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
      if(params[:commit] == "Publish")
        @post.published = true
        @post.save
      end
    end
    render :edit
  end

  def create
    @post = Post.new(post_params)
    @post.account = current_account
    @post.published = true if(params[:commit] == "Publish")
    if @post.save
      flash[:success] = "Published successfully."
    end
    render :edit
  end

  def destroy
    @post.destroy
    flash[:success] = "A post successfully deleted"
    redirect_to admin_posts_path
  end

  private

  def load_post
    @post = current_account.posts.find(params[:id])
  end
  
  private

    def post_params
      params.require(:post).permit(:title,:content, :excerpt, :video_url, :bootsy_image_gallery_id)
    end
end
