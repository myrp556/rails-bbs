every 1.day, :at => '0:00 am' do
  rake "daily:reset_today_notes"
  rake "daily:reset_user_rate_point"
end
