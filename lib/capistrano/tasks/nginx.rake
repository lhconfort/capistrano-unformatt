namespace :deploy do
  namespace :nginx do
    desc "Enables site"
    task :enable do
      on roles :web do
        execute "sudo ln -snf #{fetch(:nginx_path)}/sites-available/#{fetch(:application)} #{fetch(:nginx_path)}/sites-enabled/#{fetch(:application)}"
      end
    end

    desc "Disables site"
    task :disable do
      on roles :web do
        execute "sudo rm #{fetch(:nginx_path)}/sites-enabled/#{fetch(:application)}"
      end
    end

    desc "Reloads nginx service"
    task :reload do
      on roles :web do
        execute "sudo service nginx reload"
      end
    end

    desc "Starts nginx"
    task :start do
      on roles :web do
        execute "sudo service nginx start"
      end
    end

    desc "Stops nginx"
    task :stop do
      on roles :web do
        execute "sudo service nginx stop"
      end
    end

    desc "Restarts nginx"
    task :restart do
      on roles :web do
        execute "sudo service nginx restart"
      end
    end
  end
end
