# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Load variables from .env
  config.env.enable

  # Configure hostmanager to update /etc/hosts
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true

  env_box_name = ENV["BOX_NAME"]
  env_ram = ENV["RAM_MEMORY"]
  env_cpus = ENV["CPU_COUNT"]
  env_share_path = ENV["SHARE_PATH"]

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  
  config.vm.box = "bento/ubuntu-21.10"
  config.vm.define env_box_name
  config.vm.hostname = env_box_name
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

  config.trigger.after :up do |trigger|
    trigger.warn = "Configuring SSH and Docker via post-provisioning trigger..."
    trigger.run = {
      inline: "bash -c './trigger-up.sh \"#{env_box_name}\"'",
    }
  end

  config.trigger.before [:halt, :destroy] do |trigger|
    trigger.warn = "Cleaning up Docker and SSH configuration..."
    trigger.run = {
      inline: "bash -c './trigger-halt.sh \"#{env_box_name}\"'",
    }
  end

end
