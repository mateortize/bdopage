namespace :data do
  

  task :fix_videos => :environment do
    Video.all.each do |video|
      video.destroy unless video.valid?
    end
  end

end
