# -*- mode: ruby -*-
# vi: set ft=ruby :

domain = 'example.com'
hostonly_ip = '172.16.32.8'
Vagrant::Config.run do |config|
   config.vm.box = 'precise64'
   config.vm.box_url = 'http://files.vagrantup.com/precise64.box'
   config.vm.host_name = "newrelic.#{domain}"
   config.vm.network :hostonly, hostonly_ip

   config.vm.forward_port(8000, 8000)
    
  config.vm.share_folder "kata", "/home/vagrant/newrelic-kata", "./"
   config.vm.provision :puppet do |puppet|
     puppet.manifests_path = 'puppet/manifests'
     puppet.module_path = 'puppet/modules'
     puppet.manifest_file = 'site.pp'
   end


end
