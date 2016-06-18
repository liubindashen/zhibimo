directory "/home/deploy/zhibimo/current"

workers 24
threads 8,16

bind "unix:///home/deploy/zhibimo/shared/tmp/socks/puma.sock"
pidfile "/home/deploy/zhibimo/shared/tmp/pids/puma.pid"
state_path "/home/deploy/zhibimo/shared/tmp/states/puma.state"

preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
