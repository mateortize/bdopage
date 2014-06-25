class Admin::VideosController < Admin::BaseController
  
  before_filter :load_video, only: [:show, :update, :edit, :destroy]

  def index
    @videos = current_account.videos.order("created_at desc").page(params[:page]).per(5)
  end

  def show
  end
  
  def edit
  end

  def new
    @video = Video.new
  end

  def update
    if @video.update(video_params)
      redirect_to admin_videos_path
    else
      redirect_to edit_admin_video_path(@video)
    end
  end

  def create
    @video = Video.new(video_params)
    @video.account = current_account
    if @video.save
      UpdateVideoState.perform_async(@video.id)
      flash[:success] = "Video successfully updated, but it will take several minutes to encode."
      redirect_to admin_videos_path
    else
      flash[:danger] = @video.errors.full_messages.to_sentence
      redirect_to new_admin_video_path
    end
  end

  def destroy
    @video.destroy
    redirect_to admin_videos_path
  end


  private

  def video_params
    params.require(:video).permit(:panda_video_id, :title, :screenshot, :profile)
  end

  def load_video
    @video = current_account.videos.find(params[:id])
  end

end
