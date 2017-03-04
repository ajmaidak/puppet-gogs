Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-14.04"
  config.vm.network "private_network", ip: "192.168.50.11"
  config.vm.provision "shell" do |s|
    #s.inline = "wget -O /tmp/puppetlabs.deb http://apt.puppetlabs.com/puppetlabs-release-pc1-`lsb_release -cs`.deb && dpkg -i /tmp/puppetlabs.deb && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y puppet-agent && ln -sf /vagrant /etc/puppet/modules/gogs && ln -sf /vagrant/examples /etc/puppet/manifests && puppet module install --force puppetlabs/stdlib && puppet apply --order=random --verbose --debug /vagrant/examples/gogs_custom_user.pp"
    s.inline = "apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y puppet && ln -sf /vagrant /etc/puppet/modules/gogs && ln -sf /vagrant/examples /etc/puppet/manifests && puppet module install --force puppetlabs/stdlib && puppet apply --order=random --verbose --debug /vagrant/examples/gogs_custom_port.pp"
  end
end