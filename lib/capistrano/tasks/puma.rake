namespace :deploy do
  namespace :puma do
    desc "Starts puma"
    task :start do
      on roles :app do
        execute "#{fetch(:daemons_path)}/#{fetch(:application)}-puma start"
      end
    end

    desc "Stops puma"
    task :stop do
      on roles :app do
        execute "#{fetch(:daemons_path)}/#{fetch(:application)}-puma stop"
      end
    end

    desc "Restarts puma"
    task :restart do
      on roles :app do
        execute "#{fetch(:daemons_path)}/#{fetch(:application)}-puma restart"
      end
    end

    desc "Reloads puma"
    task :reload do
      on roles :app do
        execute "#{fetch(:daemons_path)}/#{fetch(:application)}-puma reload"
      end
    end
  end
end
