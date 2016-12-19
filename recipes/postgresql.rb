#
# Cookbook Name:: securitymonkey
# Recipe:: database
#

include_recipe 'postgresql::server' if node['postgresql']['host'] == '127.0.0.1'
include_recipe 'postgresql::client'
include_recipe 'database::postgresql'

# Create the database.
postgresql_database node['securitymonkey']['config']['database']['name'] do
  connection(
    host: node['postgresql']['host'],
    port: node['postgresql']['port'],
    username: node['postgresql']['username'],
    password:  node['postgresql']['password'][node['postgresql']['username']]
  )
  action :create
end

# Create the user.
postgresql_database_user node['securitymonkey']['config']['database']['username'] do
  connection(
    host: node['postgresql']['host'],
    port: node['postgresql']['port'],
    username: node['postgresql']['username'],
    password:  node['postgresql']['password'][node['postgresql']['username']]
  )
  password node['securitymonkey']['config']['database']['password']
  action :create
end

# Grant access to the new database.
postgresql_database_user node['securitymonkey']['config']['database']['username'] do
  connection(
    host: node['postgresql']['host'],
    port: node['postgresql']['port'],
    username: node['postgresql']['username'],
    password:  node['postgresql']['password'][node['postgresql']['username']]
  )
  database_name node['securitymonkey']['config']['database']['name']
  privileges [:all]
  action :grant
end
