# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Load variables from .env
  config.env.enable

  env_box_name = ENV["BOX_NAME"]
  env_ram = ENV["RAM_MEMORY"]
  env_cpus = ENV["CPU_COUNT"]

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  
  config.vm.box = "bento/ubuntu-21.10"
  config.vm.define env_box_name
  config.vm.hostname = env_box_name

  config.vm.provider "virtualbox" do |v|
    v.memory = env_ram
    v.cpus = env_cpus
    v.name = env_box_name
    v.gui = true
  end

  config.vm.provision :docker
  config.vm.provision "shell", path: "provision.sh"

end
