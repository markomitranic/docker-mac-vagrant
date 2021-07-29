# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Load variables from .env
  config.env.enable
  env_box_name = ENV["BOX_NAME"]
  env_ram = ENV["RAM_MEMORY"]
  env_cpus = ENV["CPU_COUNT"]
  env_share_path = ENV["SHARE_PATH"]

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.synced_folder env_share_path, env_share_path
  config.ssh.extra_args = ["-t", "cd #{env_share_path}; bash --login"]

  config.vm.provider "parallels" do |prl|
    prl.memory = env_ram
    prl.cpus = env_cpus
    prl.name = env_box_name
    prl.update_guest_tools = true
  end

  config.vm.provision :docker
  config.vm.provision "shell", path: "provision.sh"

end
