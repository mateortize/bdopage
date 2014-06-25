class UpdateVideoState
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(id)
    video = Video.find(id)
    if video.panda_video.status == 'fail'
      # video failed to be uploaded to your bucket
      # Logs go here to show this Issue
    else
      unless video.encodings.blank?
        video.encodings.each do |encoding|
          if encoding.status == "success"
            video.update_video_profile!(encoding)
          else
            Sidekiq.logger.warn "Failed: #{encoding.error_message}"
          end
        end
        video.save
      end
    end
  end
end

