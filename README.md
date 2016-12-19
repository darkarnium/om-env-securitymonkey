# Security Monkey Environment Cookbook

Provides a Chef environment cookbook for provisioning a NetFlix Security Monkey environment.

## Deployment

The following values **MUST** be overridden when Security Monkey is deployed to suit the deployed environment:

* `node['securitymonkey']['config']['fqdn']`

If deploying outside of a local / testing environment, changing the following attribute from the default (`127.0.0.1`) will disable PostgreSQL server installation automatically:

* `node['postgresql']['host']`

Further to this, Nginx will terminate SSL by default (using a self-signed certificate generated for the configured `fqdn`). If this is not required - such as in the case of termination of SSL traffic upstream - this can be disabled by changing the following attribute to `false`:

* `node['nginx']['ssl']['enable']`

## Security.

The following values **MUST** be overridden when Security Monkey is deployed outside of a local development environment:

* `node['postgresql']['password'][...]`
* `node['securitymonkey']['config']['secret_key']`
* `node['securitymonkey']['config']['security_password_salt']`

These values should be kept safe, and would ideally be set through environment or JSON override(s) with any applicable security controls applied.

## Requirements

### Platforms

Per the `.kitchen.yml` in the root of this cookbook, support is as follows:

* Ubuntu 16.04

### Chef

* Chef >= 12.1

### Cookbooks

* apt (= 5.0.0)
* ntp (= 3.2.0)
* openssl (= 4.4.0)
* database (= 4.0.6)
* postgresql (= 3.4.24)
* supervisor (= 0.4.12)
* poise-python (= 1.5.1)
* build-essential (= 7.0.2)

## Additional Reading

See the Security Monkey project documentation at the following URL:

* https://github.com/Netflix/security_monkey
