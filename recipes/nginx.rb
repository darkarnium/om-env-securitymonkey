#
# Cookbook Name:: om-env-securitymonkey
# Recipe:: nginx
#

# Install Nginx and remove the default site.
package 'nginx' do
  action :install
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
end

# Add nginx to the security-monkey group.
group node['securitymonkey']['group'] do
  append true
  action :create
  members 'www-data'
end

# Ensure nginx is started and register with Chef.
service 'nginx' do
  supports status: true
  action [:enable, :start]
end

# Create directories for SSL keys and certificates.
directory '/etc/nginx/ssl/cert/' do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  recursive true
  action :create
end

directory '/etc/nginx/ssl/private/' do
  owner 'root'
  group 'root'
  mode '0750'
  recursive true
  action :create
end

# Generate an RSA key and associated self-signed certificate.
openssl_rsa_key '/etc/nginx/ssl/private/securitymonkey.key' do
  mode '0640'
  key_length 2048
end

openssl_x509 '/etc/nginx/ssl/cert/securitymonkey.crt' do
  org node['nginx']['ssl']['org']
  mode '0640'
  group node['securitymonkey']['group']
  expire node['nginx']['ssl']['days']
  country node['nginx']['ssl']['country']
  org_unit node['nginx']['ssl']['org_unit']
  key_file '/etc/nginx/ssl/private/securitymonkey.key'
  common_name node['securitymonkey']['config']['fqdn']
end

# Install the Nginx configuration and link into service.
template '/etc/nginx/sites-available/securitymonkey.conf' do
  source 'nginx/securitymonkey.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    ssl: node['nginx']['ssl']['enable'],
    log_dir: node['securitymonkey']['dir']['log'],
    base_dir: node['securitymonkey']['dir']['base'],
    ssl_certificate: '/etc/nginx/ssl/cert/securitymonkey.crt',
    ssl_certificate_key: '/etc/nginx/ssl/private/securitymonkey.key'
  )
  notifies :restart, 'service[nginx]', :delayed
end

link '/etc/nginx/sites-enabled/securitymonkey.conf' do
  to '/etc/nginx/sites-available/securitymonkey.conf'
end
