require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina_sidekiq/tasks'
require 'mina/puma'

set :repository, 'git@github.com:zhibimo/zhibimo.git'
set :user, 'deploy'
set :deploy_to, '/home/deploy/zhibimo'

branch = ENV['branch'] || 'master'
target = ENV['target'] || 'appsrv'

set :domain, "#{target}.zhibimo"

set :branch, branch

set :shared_paths, [
  'config/database.yml',
  'config/application.yml',
  'public/uploads',
  'tmp',
  'log',
  'vendor/assets/bower_components'
]

task :environment do
  invoke :'rbenv:load'
end

task setup: :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/vendor/assets/bower_components"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/vendor/assets/bower_components"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/uploads"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue! %[touch "#{deploy_to}/shared/config/application.yml"]

  queue! %[mkdir -p "#{deploy_to}/shared/pids/"]
end

desc "Deploys the current version to the server."
task deploy: :environment do
  deploy do
    invoke :'sidekiq:quiet'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'

    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'bower:install'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :'sidekiq:restart'
      invoke :'puma:phased_restart'
    end
  end
end

namespace :bower do
  desc 'bower install'
  task :install do
    queue "cd #{deploy_to}/current && RAILS_ENV=production bundle exec rake bower:install:deployment --trace"
  end
end

namespace :bugsnag do
  desc 'bugsnag deploy'
  task :deploy do
    queue "cd #{deploy_to}/current && RAILS_ENV=production bundle exec rake bugsnag:deploy"
  end
end
