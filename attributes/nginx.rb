# Default self-signed certificate details.
default['nginx']['ssl']['days'] = 365
default['nginx']['ssl']['org'] = 'SnakeOil Redux'
default['nginx']['ssl']['country'] = 'SnakeOil Redux'
default['nginx']['ssl']['org_unit'] = 'Extraction Division'

# Whether to enable SSL in nginx (handy for SSL offload, etc).
default['nginx']['ssl']['enable'] = true
