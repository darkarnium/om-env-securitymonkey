# Security Monkey Environment Cookbook

Provides a Chef environment cookbook for provisioning a Netflix Security Monkey environment.

## Versions

Currently, this cookbook is set to use Netflix/security_monkey@51da5bf3b63da4d9474bb97c9fb9ffe3e5cc104a. This is due to there being fixes required to psycopg2 back @ Netflix/security_monkey@a5a913b8b4cb9fccd34677112a939074e2310848 which prevents Security Monkey from being used with PostgreSQL 10.X.

If desired, the version of Security Monkey to install can be changed by overriding the `node['securitymonkey']['git']['ref']` attribute.

## Deployment

The following values **MUST** be overridden when Security Monkey is deployed to suit the deployed environment:

* `node['securitymonkey']['config']['fqdn']`

If deploying outside of a local / testing environment, changing the following attribute from the default (`127.0.0.1`) will disable PostgreSQL server installation automatically:

* `node['postgresql']['host']`

Further to this, Nginx will terminate SSL by default (using a self-signed certificate generated for the configured `fqdn`). If this is not required - such as in the case of termination of SSL traffic upstream - this can be disabled by changing the following attribute to `false`:

* `node['nginx']['ssl']['enable']`

## Security

The following values **MUST** be overridden when Security Monkey is deployed outside of a local development environment:

* `node['postgresql']['password'][...]`
* `node['securitymonkey']['config']['secret_key']`
* `node['securitymonkey']['config']['security_password_salt']`

These values should be kept safe, and would ideally be set through environment, JSON override(s), or another more secure mechanism adhering to any applicable security controls.

## Requirements

### Platforms

Per the `.kitchen.yml` in the root of this cookbook, support is as follows:

* Ubuntu 14.04
* Ubuntu 16.04

### Chef

Although this cookbook may work with other Chef versions it has only been tested on the following:

* Chef >= 13.6

### Cookbooks

* apt (= 6.1.4)
* ntp (= 3.5.4)
* openssl (= 7.1.0)
* database (= 6.1.1)
* postgresql (= 6.1.1)
* poise-python (= 1.6.0)
* build-essential (= 8.0.4)

## Additional Reading

See the Security Monkey project documentation at the following URL:

* https://github.com/Netflix/security_monkey
