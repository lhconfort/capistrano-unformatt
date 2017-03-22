set :setup_yamls, []
set :setup_daemons, []
set :setup_nginx, false

load File.expand_path("../../tasks/setup.rake", __FILE__)
