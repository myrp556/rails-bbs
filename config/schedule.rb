every 1.day, :at => '0:00 am' do
  rake "daily:reset_today_notes"
  rake "daily:reset_user_rate_point"
end

every 1.hour do
  rake "daily:reset_topic_hot"
end
