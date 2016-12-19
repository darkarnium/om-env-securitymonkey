#
# Cookbook Name:: securitymonkey
# Recipe:: application
#

# Ensure required dependencies and runtime(s) are installed.
python_runtime '2'

node['securitymonkey']['dependencies'].each do |dependency|
  package dependency do
    action :install
  end
end

# Create a user and group for security monkey.
group node['securitymonkey']['group'] do
  append true
  action :create
end

user node['securitymonkey']['user'] do
  group node['securitymonkey']['group']
  comment 'NetFlix Security Monkey'
end

# Create the base directory and setup a virtualenv.
directory node['securitymonkey']['dir']['base'] do
  user node['securitymonkey']['user']
  mode 00750
  group node['securitymonkey']['group']
  recursive true
  action :create
end

git node['securitymonkey']['dir']['base'] do
  user node['securitymonkey']['user']
  group node['securitymonkey']['group']
  action :sync
  reference  node['securitymonkey']['git']['ref']
  repository node['securitymonkey']['git']['repo']
end

# Write out the deployment configuration template.
template ::File.join(node['securitymonkey']['dir']['config'], 'config-deploy.py') do
  source 'config-deploy.py.erb'
  user node['securitymonkey']['user']
  group node['securitymonkey']['group']
  variables(
    fqdn: node['securitymonkey']['config']['fqdn'],
    log_dir: node['securitymonkey']['dir']['log'],
    secret_key: node['securitymonkey']['config']['secret_key'],
    postgres_host: node['postgresql']['host'],
    postgres_port: node['postgresql']['port'],
    postgres_username: node['securitymonkey']['config']['database']['username'],
    postgres_password: node['securitymonkey']['config']['database']['password'],
    postgres_database: node['securitymonkey']['config']['database']['name'],
    security_password_salt: node['securitymonkey']['config']['secret_key']
  )
  mode 00640
end

python_virtualenv 'securitymonkey' do
  path node['securitymonkey']['dir']['venv']
  user node['securitymonkey']['user']
  group node['securitymonkey']['group']
  notifies :run, 'python_execute[install]', :immediately
end

# Fetch and install security monkey.
python_execute 'install' do
  cwd node['securitymonkey']['dir']['base']
  action :nothing
  command 'setup.py install'
  virtualenv 'securitymonkey'
  environment node['securitymonkey']['environment']
end

# Ensure the log directory exists and is correctly owned.
directory node['securitymonkey']['dir']['log'] do
  owner node['securitymonkey']['user']
  group node['securitymonkey']['group']
  mode 00750
  recursive true
  action :create
end

# Build the Web UI.
execute 'dart-get' do
  cwd ::File.join(node['securitymonkey']['dir']['base'], 'dart')
  user node['securitymonkey']['user']
  action :run
  command '/usr/lib/dart/bin/pub get'
  environment(
    PUB_CACHE: ::File.join(node['securitymonkey']['dir']['base'])
  )
end

execute 'dart-build' do
  cwd ::File.join(node['securitymonkey']['dir']['base'], 'dart')
  user node['securitymonkey']['user']
  action :run
  command '/usr/lib/dart/bin/pub build'
  environment(
    PUB_CACHE: ::File.join(node['securitymonkey']['dir']['base'])
  )
end

# Link in static assets.
link ::File.join(node['securitymonkey']['dir']['base'], 'security_monkey/static') do
  to ::File.join(node['securitymonkey']['dir']['base'], 'dart/build/web')
end

# Migrate databases.
python_execute 'db-upgrade' do
  cwd node['securitymonkey']['dir']['base']
  user node['securitymonkey']['user']
  action :run
  command 'manage.py db upgrade'
  virtualenv 'securitymonkey'
  environment node['securitymonkey']['environment']
end

# Create and install supervisor services.
supervisor_command = format(
  '%{python} %{script}',
  python: ::File.join(node['securitymonkey']['dir']['venv'], '/bin/python'),
  script: ::File.join(node['securitymonkey']['dir']['base'], 'manage.py')
)

supervisor_service 'securitymonkey' do
  user node['securitymonkey']['user']
  command "#{supervisor_command} run_api_server"
  directory node['securitymonkey']['dir']['base']
  autostart true
  autorestart true
  environment node['securitymonkey']['environment']
end

supervisor_service 'securitymonkeyscheduler' do
  user node['securitymonkey']['user']
  command "#{supervisor_command} start_scheduler"
  directory node['securitymonkey']['dir']['base']
  autostart true
  autorestart true
  environment node['securitymonkey']['environment']
end
