namespace :deploy do
  namespace :install do
    desc "Creates config for yml"
    task :yaml, :command do |task, args|
      append :templating_paths, File.expand_path('../../../vendor/templates', File.dirname(__FILE__))

      on roles :app do
        execute "mkdir -p #{shared_path}/{config,tmp,log,pids}"

        yamls = fetch(:setup_yamls, [])
        yamls.keep_if { |x| args[:command].split('/').map(&:strip).include?(x.to_s) }

        yamls.each do |yaml|
          template "#{yaml}.yml.erb", "#{shared_path}/config/#{yaml}.yml"
        end
      end
    end

    desc "Creates config for daemon"
    task :daemon, :command do |task, args|
      append :templating_paths, File.expand_path('../../../vendor/templates', File.dirname(__FILE__))

      on roles :app do
        execute "mkdir -p #{shared_path}/{config,tmp,log,pids}"

        daemons = fetch(:setup_daemons, [])
        daemons.keep_if { |x| args[:command].split('/').map(&:strip).include?(x[:name].to_s) }

        daemons.each do |daemon|
          if daemon[:config] == true
            template "#{daemon[:name]}.rb.erb", "#{shared_path}/config/#{daemon[:name]}.rb", 0644
          end

          template "#{daemon[:name]}.daemon.erb", "#{shared_path}/tmp/#{daemon[:name]}.daemon", 0755
          execute "sudo mv -f #{shared_path}/tmp/#{daemon[:name]}.daemon #{fetch(:daemons_path)}/#{fetch(:application)}-#{daemon[:name]}"

          template "#{daemon[:name]}.monit.erb", "#{shared_path}/tmp/#{daemon[:name]}.monit", 0644
          execute "sudo mv -f #{shared_path}/tmp/#{daemon[:name]}.monit #{fetch(:monit_scripts_path)}/#{fetch(:application)}-#{daemon[:name]}"
        end
      end
    end

    desc "Creates config for nginx"
    task :nginx do
      append :templating_paths, File.expand_path('../../../vendor/templates', File.dirname(__FILE__))

      on roles :web do
        execute "mkdir -p #{shared_path}/{config,tmp,log,pids}"

        template "nginx.conf.erb", "#{shared_path}/tmp/nginx.conf", 0644
        execute "sudo mv -f #{shared_path}/tmp/nginx.conf #{fetch(:nginx_path)}/sites-available/#{fetch(:application)}"
        execute "sudo ln -snf #{fetch(:nginx_path)}/sites-available/#{fetch(:application)} #{fetch(:nginx_path)}/sites-enabled/#{fetch(:application)}"
      end
    end

    desc "Creates all project files."
    task :all do
      unless ENV['SKIP_YAMLS'] == 'true'
        yaml_names_param = fetch(:setup_yamls, []).map { |x| x.to_s }.join('/')
        invoke "deploy:install:yaml[#{yaml_names_param}]"
      end

      unless ENV['SKIP_DAEMONS'] == 'true'
        daemon_names_param = fetch(:setup_daemons, []).map { |x| x[:name].to_s }.join('/')
        invoke "deploy:install:daemon[#{daemon_names_param}]"
      end

      if fetch(:setup_nginx, false) == true
        invoke "deploy:install:nginx"
      end
    end
  end

  namespace :uninstall do
    desc "Removes all project files."
    task :all do
      on roles :all do
        fetch(:setup_daemons, []).each do |daemon|
          execute "sudo monit stop #{fetch(:application)}-#{daemon[:name]}", raise_on_non_zero_exit: false
          execute "sudo rm -f /etc/init.d/#{fetch(:application)}-#{daemon[:name]}"
          execute "sudo rm -f /etc/monit/conf.d/#{fetch(:application)}-#{daemon[:name]}"
        end

        if fetch(:setup_nginx, false) == true
          execute "sudo rm -f /etc/nginx/sites_available/#{fetch(:application)}"
          execute "sudo rm -f /etc/nginx/sites_enabled/#{fetch(:application)}"
        end

        if fetch(:erase_deploy_folder_on_uninstall, false) == true
          execute "rm -rf #{fetch(:deploy_to)}"
        end
      end
    end
  end
end
