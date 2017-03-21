namespace :deploy do
  namespace :sidekiq do
    desc "Starts sidekiq"
    task :start do
      on roles :app do
        execute "#{fetch(:daemons_path)}/#{fetch(:application)}-sidekiq start"
      end
    end

    desc "Stops sidekiq"
    task :stop do
      on roles :app do
        execute "#{fetch(:daemons_path)}/#{fetch(:application)}-sidekiq stop"
      end
    end

    desc "Restarts sidekiq"
    task :restart do
      on roles :app do
        execute "#{fetch(:daemons_path)}/#{fetch(:application)}-sidekiq restart"
      end
    end

    desc "Rejects new sidekiq jobs"
    task :reject_jobs do
      on roles :app do
        execute "#{fetch(:daemons_path)}/#{fetch(:application)}-sidekiq reject_jobs"
      end
    end
  end
end
