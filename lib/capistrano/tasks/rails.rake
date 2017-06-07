namespace :deploy do
  namespace :rails do
    desc "Executes rake db:seed on project"
    task :seed do
      on roles :app do
        within current_path do
          with rails_env: "#{fetch(:rails_env)}" do
            execute :rake, "db:seed"
          end
        end
      end
    end
  end
end
