set :setup_yamls, []
set :setup_daemons, []
set :nginx_protocols, ['http']
set :setup_nginx, false

set :app_server_host, '127.0.0.1'
set :app_server_port, 3000

load File.expand_path("../../tasks/setup.rake", __FILE__)
