#
# Cookbook Name:: om-env-securitymonkey
# Recipe:: default
#

include_recipe 'apt'
include_recipe 'ntp::default'

include_recipe 'om-env-securitymonkey::dart'
include_recipe 'om-env-securitymonkey::nginx'
include_recipe 'om-env-securitymonkey::postgresql'
include_recipe 'om-env-securitymonkey::application'
