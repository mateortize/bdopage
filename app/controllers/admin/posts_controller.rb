class Admin::PostsController < Admin::BaseController

  before_filter :load_post, only: [:show, :update, :edit, :destroy, :publish, :unpublish]
  
  set_tab :post

  def index
    @posts = current_account.posts.order("created_at desc").page(params[:page]).per(12)
  end

  def new
    @post = Post.new
    @post.account = current_account
  end

  def show
  end

  def edit
    @post.valid?
  end

  def update
    if @post.update_attributes(post_params)
      flash[:success] = "Updated successfully."
    end
    render :edit
  end

  def create
    @post = Post.new(post_params)
    @post.account = current_account
    if @post.save_draft!
      flash[:success] = "Created successfully"
    end

    if @post.has_embeded_video?
      render :edit
    else
      redirect_to new_admin_post_video_path(@post) 
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "Deleted successfully"
    redirect_to admin_posts_path
  end

  def publish
    if @post.publish!
      flash[:success] = "Published successfully."
      redirect_to admin_posts_path
    else
      redirect_to edit_admin_post_path(@post)
    end
  end

  def unpublish
    if @post.unpublish!
      flash[:success] = "Unpublished successfully."
      redirect_to admin_posts_path
    else
      redirect_to edit_admin_post_path(@post)
    end
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
