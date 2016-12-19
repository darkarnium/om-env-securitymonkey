VAGRANTFILE_API_VERSION = '2'.freeze

Vagrant.require_version '>= 1.5.0'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'securitymonkey'

  config.berkshelf.enabled = true
  if Vagrant.has_plugin?('vagrant-omnibus')
    config.omnibus.chef_version = 'latest'
  end

  config.vm.box = 'ubuntu/trusty64'
  config.vm.network :private_network, type: 'dhcp'
  config.vm.network 'forwarded_port', guest: 443, host: 8443
  config.vm.network 'forwarded_port', guest: 80, host: 8080

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048']
  end

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      'postgresql' => {
        'password' => {
          'postgres' => 'aVeryStrongPassword'
        }
      },
      'securitymonkey' => {
        'config' => {
          'fqdn' => 'localhost',
          'secret_key' => 'aVerySecretKey',
          'security_password_salt' => 'theSaltiestOfSalts'
        }
      }
    }

    chef.run_list = [
      'recipe[securitymonkey]'
    ]
  end
end
