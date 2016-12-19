#
# Cookbook Name:: securitymonkey
# Recipe:: dart
#

# Configure the Dart APT repository and install.
apt_repository 'dart' do
  uri node['dart']['apt']['uri']
  key node['dart']['apt']['key']
  arch 'amd64'
  components node['dart']['apt']['components']
  distribution ''
end

package 'dart' do
  action :install
end
