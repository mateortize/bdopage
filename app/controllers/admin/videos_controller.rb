class Admin::VideosController < Admin::BaseController
  
  before_filter :load_post
  before_filter :load_video, only: [:update, :destroy, :show, :edit]

  set_tab :video

  def new
    @video = Video.new
  end
  
  def show
  end
  
  def edit
  end

  def update
    if @video.update(video_params)
      redirect_to edit_admin_post_path(@post)
    else
      render :edit
    end
  end

  def create
    @video = Video.new(video_params)
    @video.account = current_account
    @video.post = @post
    if @video.save
      UpdateVideoState.perform_async(@video.id)
      flash[:success] = "Video successfully updated, but it will take several minutes to encode."
    else
      flash[:danger] = @video.errors.full_messages.to_sentence
    end
    redirect_to edit_admin_post_path(@post)
  end

  def destroy
    @video.destroy
    redirect_to edit_admin_post_path(@post)
  end


  private

  def video_params
    params.require(:video).permit(:panda_video_id)
  end

  def load_video
    @video = @post.video
  end

  def load_post
    @post = current_account.posts.find(params[:post_id])
  end
end
