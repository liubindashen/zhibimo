require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

set :repository, 'git@github.com:peatio/yunbi.git'
set :user, 'deploy'
set :deploy_to, '/home/deploy/yunbi'

branch = ENV['branch'] || 'production'

DEPLOY_LIST = %w(web-01.public web-02.public web.admin daemon-master.core daemon-slave.core app.staging)

if DEPLOY_LIST.include?(ENV['to'])
  set :machine, ENV['to']
  set :domain, ENV['to'] + ".yunbi"
else
  raise 'unknow deploy domain'
end

set :branch, branch

set :shared_paths, [
  'config/database.yml',
  'config/application.yml',
  'config/amqp.yml',
  'config/rpc.yml',
  'config/deposit_accounts.yml',
  'config/roles.yml',
  'public/uploads',
  'tmp',
  'log'
]

task :environment do
  invoke :'rbenv:load'
end

task setup: :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/uploads"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue! %[touch "#{deploy_to}/shared/config/application.yml"]
  queue! %[touch "#{deploy_to}/shared/config/amqp.yml"]
  queue! %[touch "#{deploy_to}/shared/config/rpc.yml"]
  queue! %[touch "#{deploy_to}/shared/config/deposit_accounts.yml"]
end

desc "Deploys the current version to the server."
task deploy: :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'

    if %(web.admin app.staging).include?(machine)
      invoke :'rails:db_migrate'
    end

    if %(web.admin web-01.public web-02.public app.staging).include?(machine)
      invoke :'rails:touch_client_i18n_assets'
      invoke :'rails:assets_precompile'
    end

    to :launch do
      invoke :non_digested_assets
      invoke :del_admin
      invoke :del_daemons
      invoke :'passenger:restart'
      invoke :bugsnag_deploy
    end
  end
end

namespace :passenger do
  desc "Restart Passenger"
  task :restart do
    queue %{
      echo "-----> Restarting passenger"
      cd #{deploy_to}/current
      #{echo_cmd %[mkdir -p tmp]}
      #{echo_cmd %[touch tmp/restart.txt]}
    }
  end
end

namespace :rails do
  task :touch_client_i18n_assets do
    queue %[
      echo "-----> Touching clint i18n assets"
      #{echo_cmd %[RAILS_ENV=production bundle exec rake deploy:touch_client_i18n_assets]}
    ]
  end
end

desc 'delete admin'
task :del_admin do
  unless %(web.admin app.staging).include?(machine)
    queue! "rm -rf #{deploy_to}/current/app/admin"
    queue! "sed -i '/ActiveAdmin\.routes\(self\)/d' #{deploy_to}/current/config/routes.rb"
  end
end

@required_daemons = %w(amqp_daemon.rb daemons)
@redis_daemons = %w(stats.rb stats_ctl slack_ctl amqp_daemon.rb daemons)

def remove_daemons(daemons: nil)
  if daemons
    daemons -= @required_daemons
    daemons.each {|d| queue! "rm -rf #{deploy_to}/current/lib/daemons/#{d}" }
  else
    queue! "rm -rf #{deploy_to}/current/lib/daemons"
    queue! "rm -rf #{deploy_to}/current/app/models/worker"
  end
end

def remove_except(daemons)
  daemons |= @required_daemons
  unless daemons.empty?
    Dir[File.dirname(__FILE__)+'/../lib/daemons/*'].each do |path|
      filename = File.basename(path)
      if not daemons.include?(filename)
        queue! "rm -rf #{deploy_to}/current/lib/daemons/#{filename}"
      end
    end
  end
end

desc 'delete daemons'
task :del_daemons do
  case machine
  when 'web.admin', 'web-01.public', 'web-02.public'
    remove_daemons
  when 'daemon-master.core'
    remove_daemons daemons: @redis_daemons
  when 'daemon-slave.core'
    remove_except @redis_daemons
  end
end

namespace :daemons do
  desc "Start Daemons"
  task start: :environment do
    queue %{
      cd #{deploy_to}/current
      RAILS_ENV=production bundle exec ./bin/rake daemons:start
      echo Daemons START DONE!!!
    }
  end

  desc "Stop Daemons"
  task stop: :environment do
    queue %{
      cd #{deploy_to}/current
      RAILS_ENV=production bundle exec ./bin/rake daemons:stop
      echo Daemons STOP DONE!!!
    }
  end

  desc "Query Daemons"
  task status: :environment do
    queue %{
      cd #{deploy_to}/current
      RAILS_ENV=production bundle exec ./bin/rake daemons:status
    }
  end
end

desc 'non digested assets'
task :non_digested_assets do
  queue "cd #{deploy_to}/current && RAILS_ENV=production bundle exec rake deploy:non_digested_assets"
end

desc 'bugsnag deploy'
task :bugsnag_deploy do
  queue "cd #{deploy_to}/current && RAILS_ENV=production bundle exec rake bugsnag:deploy"
end

desc "Generate liability proof"
task 'solvency:liability_proof' do
  queue "cd #{deploy_to}/current && RAILS_ENV=production bundle exec rake solvency:liability_proof"
end

