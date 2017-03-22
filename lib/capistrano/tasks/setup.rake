namespace :deploy do
  desc "Creates project files."
  task :install do
    append :templating_paths, File.expand_path('../../../vendor/templates', File.dirname(__FILE__))

    on roles :app do
      # yaml files
      execute "mkdir -p #{shared_path}/{config,tmp}"

      fetch(:setup_yamls, []).each do |yaml|
        template "#{yaml}.yml.erb", "#{shared_path}/config/#{yaml}.yml"
      end

      fetch(:setup_daemons, []).each do |daemon|
        if daemon[:config] == true
          template "#{daemon[:name]}.rb.erb", "#{shared_path}/config/#{daemon[:name]}.rb", 0644
        end

        template "#{daemon[:name]}.daemon.erb", "#{shared_path}/tmp/#{daemon[:name]}.daemon", 0755
        execute "sudo mv -f #{shared_path}/tmp/#{daemon[:name]}.daemon #{fetch(:daemons_path)}/#{fetch(:application)}-#{daemon[:name]}"

        template "#{daemon[:name]}.monit.erb", "#{shared_path}/tmp/#{daemon[:name]}.monit", 0644
        execute "sudo mv -f #{shared_path}/tmp/#{daemon[:name]}.monit #{fetch(:monit_scripts_path)}/#{fetch(:application)}-#{daemon[:name]}"
      end

      execute "sudo service monit reload"
    end

    if fetch(:setup_nginx, false) == true
      on roles :web do
        execute "mkdir -p #{fetch(:deploy_to)}"
        template "nginx.conf.erb", "#{shared_path}/tmp/nginx.conf", 0644
        execute "sudo mv -f #{shared_path}/tmp/nginx.conf #{fetch(:nginx_path)}/sites-available/#{fetch(:application)}"
        execute "sudo ln -snf #{fetch(:nginx_path)}/sites-available/#{fetch(:application)} #{fetch(:nginx_path)}/sites-enabled/#{fetch(:application)}"
        execute "sudo service nginx reload"
      end
    end
  end

  desc "Removes all project files."
  task :uninstall do
    on roles :all do
      fetch(:setup_daemons, []).each do |daemon|
        execute "sudo monit stop #{fetch(:application)}-#{daemon[:name]}", raise_on_non_zero_exit: false
        execute "sudo rm -f /etc/init.d/#{fetch(:application)}-#{daemon[:name]}"
        execute "sudo rm -f /etc/monit/conf.d/#{fetch(:application)}-#{daemon[:name]}"
      end

      if fetch(:setup_daemons, []).any?
        execute "sudo service monit reload"
      end

      if fetch(:setup_nginx, false) == true
        execute "sudo rm -f /etc/nginx/sites_available/#{fetch(:application)}"
        execute "sudo rm -f /etc/nginx/sites_enabled/#{fetch(:application)}"
        execute "sudo service nginx reload"
      end

      if fetch(:erase_deploy_folder_on_uninstall, false) == true
        execute "rm -rf #{fetch(:deploy_to)}"
      end
    end
  end
end
