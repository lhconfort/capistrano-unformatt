namespace :deploy do
  namespace :sunspot do
    desc "Starts sunspot"
    task :start do
      on roles :app do
        execute "#{fetch(:daemons_path)}/#{fetch(:application)}-sunspot start"
      end
    end

    desc "Stops sunspot"
    task :stop do
      on roles :app do
        execute "#{fetch(:daemons_path)}/#{fetch(:application)}-sunspot stop"
      end
    end

    desc "Restarts sunspot"
    task :restart do
      on roles :app do
        execute "#{fetch(:daemons_path)}/#{fetch(:application)}-sunspot restart"
      end
    end
  end
end
