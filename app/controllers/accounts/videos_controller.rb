class Accounts::VideosController < Accounts::BaseController
  
  before_filter :load_video, only: [:show, :update, :edit, :destroy]
  before_filter :update_video_status, only: [:edit]

  def index
    @videos = current_account.videos.order("created_at").page(params[:page]).per(5)
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
      redirect_to accounts_videos_path
    else
      redirect_to edit_accounts_video_path(@video)
    end
  end

  def create
    @video = Video.new(video_params)
    @video.account = current_account
    if @video.save
      flash[:success] = "Video successfully updated"
      redirect_to accounts_videos_path
    else
      flash[:danger] = @video.errors.full_messages.to_sentence
      redirect_to new_accounts_video_path
    end
  end

  def destroy
    @video.destroy
    redirect_to accounts_videos_path
  end




  private

  def video_params
    params.require(:video).permit(:panda_video_id, :title, :screenshot, :profile)
  end

  def load_video
    @video = current_account.videos.find(params[:id])
  end

  def update_video_status
    unless @video.encoded
      unless @video.panda_video.status == 'fail'
        @video.encoded = true
      end
    end
  end

end
