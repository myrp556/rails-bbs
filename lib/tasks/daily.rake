namespace :daily do
  desc 'reset zone.today_notes'
  task :reset_today_notes => :environment do
    for zone in Zone.all
      zone.update(today_notes: 0)
    end
  end

  task :reset_user_rate_point => :environment do
    for user in User.all
      user.update(rate_point: Settings.user_max_rate_point)
    end
  end
end
