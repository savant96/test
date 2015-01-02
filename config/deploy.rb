# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'test'
set :repo_url, 'https://github.com/savant96/test'
set :use_sudo, false

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
 #set :deploy_to, '/var/www/testapp'
  set :deploy_to, '/home/deploy/Rails/test'

# Default value for :scm is :git
 set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
 set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
 set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end


desc "Symlink shared config files"
  task :symlink_config_database do
  on roles :all do
     execute "ln -s home/deploy/Rails/shared/database.yml #{ current_path }/config/database.yml"
  end
end

desc "Symlink shared config files"
  task :symlink_config_secrets do
  on roles :all do
     execute "ln -s home/deploy/Rails/shared/secrets.yml #{ current_path }/config/secrets.yml"
  end
end


 desc "rake db"
  task :rake_db do 
   on roles :all do
  execute  " cd #{ deploy_to }/current/"
    execute   "source /usr/local/rvm/scripts/rvm rake db:migrate RAILS_ENV=production"
 
    end
  end
 # NOTE: I don't use this anymore, but this is how I used to do it.
  desc "Precompile assets after deploy"
  task :precompile_assets do
  on roles :all do  
  
    execute  " cd #{ deploy_to }/current/"
    execute   "  source /usr/local/rvm/scripts/rvm rake assets:precompile RAILS_ENV=production"
        
  end 
 end


 

desc "Reload apache"
task :restart do
  on roles :all do
    execute "service apache2 reload"
  end
 end



end




after "deploy", "deploy:symlink_config_database"
after "deploy", "deploy:symlink_config_secrets"
after "deploy", "deploy:rake_db"
after "deploy", "deploy:precompile_assets"
after "deploy", "deploy:restart"
