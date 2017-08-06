namespace :db_reset do
  desc "dev reset and init db"
  task(:dev) do
    sh "rake db:drop:all RAILS_ENV=development"
    sh "rake db:create:all RAILS_ENV=development"
    sh "rake db:migrate RAILS_ENV=development"
    sh "rake db:seed"
  end

  desc "pdk reset and init db"
  task(:pdk) do
    sh "rake db:drop:all RAILS_ENV=production"
    sh "rake db:create:all RAILS_ENV=production"
    sh "rake db:migrate RAILS_ENV=production"
  end
end
