#
# Cookbook Name:: securitymonkey
# Recipe:: default
#

include_recipe 'apt'
include_recipe 'ntp::default'

include_recipe 'securitymonkey::dart'
include_recipe 'securitymonkey::nginx'
include_recipe 'securitymonkey::postgresql'
include_recipe 'securitymonkey::application'
