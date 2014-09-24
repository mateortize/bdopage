namespace :data do
  

  task :fix_videos => :environment do
    Video.all.each do |video|
      video.destroy unless video.valid?
    end
  end

  task :fix_account_profiles => :environment do
    Account.all.each do |account|
      if account.profile.blank?
        account.create_profile()
      end
    end
  end

end
