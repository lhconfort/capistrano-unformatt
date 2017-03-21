namespace :deploy do
  namespace :sunspot do
    desc "Starts sunspot"
    task :start do
      on roles :app do
        execute "#{daemons_path}/#{fetch(:application)}-sunspot start"
      end
    end

    desc "Stops sunspot"
    task :stop do
      on roles :app do
        execute "#{daemons_path}/#{fetch(:application)}-sunspot stop"
      end
    end

    desc "Starts sunspot"
    task :restart do
      on roles :app do
        execute "#{daemons_path}/#{fetch(:application)}-sunspot restart"
      end
    end
  end
end
