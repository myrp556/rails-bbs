# -*- coding: utf-8 -*-
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 1)
timeout 15
preload_app true  # 更新時ダウンタイム無し

listen "/home/jsd/rails-bbs/tmp/unicorn.sock"
pid "/home/jsd/rails-bbs/tmp/unicorn.pid"

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

stderr_path File.expand_path('log/unicorn.err.log', ENV['RAILS_ROOT'])
stdout_path File.expand_path('log/unicorn.acc.log', ENV['RAILS_ROOT'])
