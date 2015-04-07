require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :user, 'deployer'    # Username in the server to SSH to.
set :domain, '185.82.172.101'

set :deploy_to, '/home/deployer/cinemaplace'
set :forward_agent, true

set :repository, 'https://github.com/dimaursu/diaspora.git'
set :branch, 'boostrap2'

set :rails_env, 'production'
set :chruby_path, '/usr/local/share/chruby/chruby.sh'


# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, [
  'config/database.yml',
  'config/diaspora.yml',
  'log',
  'public/system',
  'public/uploads',
]

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  invoke :'rvm:use[ruby-2.1]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/pids"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'
    #queue "RAILS_ENV=production bundle exec foreman start > #{deploy_to}/#{shared_path}/log/foreman.txt 2>&1 &"

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/pids/"
      #queue "kill -HUP << #{deploy_to}/#{shared_path}/pids/diaspora.pid"
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

