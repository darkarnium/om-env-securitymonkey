# Installation source and destination.
default['securitymonkey']['git']['ref'] = '51da5bf3b63da4d9474bb97c9fb9ffe3e5cc104a'
default['securitymonkey']['git']['repo'] = 'https://github.com/Netflix/security_monkey.git'

# Who to run Security Monkey as.
default['securitymonkey']['user'] = 'securitymonkey'
default['securitymonkey']['group'] = 'www-data'

# Security Monkey directories.
default['securitymonkey']['dir']['log'] = '/var/log/security_monkey'
default['securitymonkey']['dir']['base'] = '/usr/local/src/security_monkey'
default['securitymonkey']['dir']['venv'] = ::File.join(
  node['securitymonkey']['dir']['base'], '.virtualenv'
)
default['securitymonkey']['dir']['config'] = ::File.join(
  node['securitymonkey']['dir']['base'], 'env-config'
)

# Security Monkey database configuration.
default['securitymonkey']['config']['database']['name'] = 'securitymonkey'
default['securitymonkey']['config']['database']['username'] = 'securitymonkey'
default['securitymonkey']['config']['database']['password'] = 'securitymonkey'

# Security Monkey application configuration.
default['securitymonkey']['config']['fqdn'] = 'localhost'
default['securitymonkey']['config']['secret_key'] = 'NotMyCircus'
default['securitymonkey']['config']['mail_default_sender'] = 'robot@example.org'
default['securitymonkey']['config']['security_password_salt'] = 'MonkeyBusiness'

# Ubuntu dependencies for Security Monkey.
default['securitymonkey']['dependencies'] = [
  'git',
  'libpq-dev',
  'libffi-dev',
  'supervisor',
  'libyaml-dev',
]

# Define a set of environment variables to be passed to any and all Security
# Monkey scripts.
default['securitymonkey']['environment'] = {
  PYTHON_EGG_CACHE: ::File.join(
    node['securitymonkey']['dir']['base'], '.cache/Python-Eggs/'
  ),
  SECURITY_MONKEY_SETTINGS: ::File.join(
    node['securitymonkey']['dir']['config'], 'config-deploy.py'
  ),
}
