namespace :deploy do
  namespace :monit do
    desc "Reloads monit service"
    task :reload do
      on roles :app do
        execute "sudo monit reload"
      end
    end

    desc "Starts applications"
    task :start do
      if ENV['DAEMONS'].present?
        on roles :app do
          ENV['DAEMONS'].split(',').each do |daemon|
            execute "sudo monit start #{fetch(:application)}-#{daemon}"
          end
        end
      else
        execute "sudo monit -g #{fetch(:application)} start all"
      end
    end

    desc "Stops applications"
    task :stop do
      if ENV['DAEMONS'].present?
        on roles :app do
          ENV['DAEMONS'].split(',').each do |daemon|
            execute "sudo monit stop #{fetch(:application)}-#{daemon}"
          end
        end
      else
        execute "sudo monit -g #{fetch(:application)} stop all"
      end
    end

    desc "Restarts applications"
    task :restart do
      if ENV['DAEMONS'].present?
        on roles :app do
          ENV['DAEMONS'].split(',').each do |daemon|
            execute "sudo monit restart #{fetch(:application)}-#{daemon}"
          end
        end
      else
        execute "sudo monit -g #{fetch(:application)} restart all"
      end
    end

    desc "Starts monitoring applications"
    task :monitor do
      if ENV['DAEMONS'].present?
        on roles :app do
          ENV['DAEMONS'].split(',').each do |daemon|
            execute "sudo monit monitor #{fetch(:application)}-#{daemon}"
          end
        end
      else
        execute "sudo monit -g #{fetch(:application)} monitor all"
      end
    end

    desc "Stops monitoring applications"
    task :unmonitor do
      if ENV['DAEMONS'].present?
        on roles :app do
          ENV['DAEMONS'].split(',').each do |daemon|
            execute "sudo monit unmonitor #{fetch(:application)}-#{daemon}"
          end
        end
      else
        execute "sudo monit -g #{fetch(:application)} unmonitor all"
      end
    end
  end
end
