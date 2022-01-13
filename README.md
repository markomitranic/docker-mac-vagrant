# Docker in Vagrant

This repository automates the provisioning of a Vagrant VM that acts as a hypervisor. In other words, it effortlessly replaces the slow parts of Docker for Mac. Your code runs faster, battery lasts longer and fans spin less - and you don't have to change anything about your projects.

[D4M is slow](https://medium.com/homullus/docker-for-mac-performance-diy-d4m-e4232ca8b671). Primarily because of its osxfs/grpcfuse sharing filesystem. On the other hand, Parallels has their own proprietary fs sharing driver, and it works at almost native speeds. Unfortunately for us all, Vbox and VMWare do not seem to have the same performance.

- [Docker in Vagrant](#docker-in-vagrant)
- [Using the workbox, day-to-day](#using-the-workbox-day-to-day)
- [Initial Setup](#initial-setup)
  - [Provisioning the VM](#provisioning-the-vm)
  - [First time Connecting VSCode](#first-time-connecting-vscode)
- [Reasoning](#reasoning)
    - [Container-first](#container-first)
  - [Remote coding How-tos](#remote-coding-how-tos)
- [Tips & Tricks](#tips--tricks)
  - [Cleaning up from time to time](#cleaning-up-from-time-to-time)

# Using the workbox, day-to-day
1. If not started, start the box `vagrant up`
2. Open VSCode and connect in one of the three ways:
   1. If t was your last open window, it will automatically reconnect.
   2. From the menu File > Open Recent.
   3. `Cmd + Shift + P` and type "Remote-SSH: Connect to Remote Host"

For more usage examples and videos, read [my article](https://medium.com/homullus/remote-development-or-how-i-learned-to-stop-worrying-and-love-the-mainframe-90165147a57d#fde9)

# Initial Setup
## Provisioning the VM

1. Install VirtualBox on your Mac: `brew install --cask virtualbox`
2. Install other prerequisites like vagrant cli, plugins for it and dotenv file with some sane defaults: `./setup.sh`
3. Start vagrant with: `vagrant up`
4. Set up SSH forwarding:
  ```bash
  vagrant ssh-config >>  ~/.ssh/config
  echo "  ForwardAgent yes" >>  ~/.ssh/config
  ```
5. (optional) Add it to your hosts file. The VM will provide a private IP address that you can add to your hosts file. The Address is static and controlled via your `.env`

## First time Connecting VSCode
1. Clone the VSCode project settings repository. 
   ```bash
   ssh workbox
   git clone git@github.com:markomitranic/.vscode.git /home/vagrant/projects/.vscode
   ```
2. Start VSCode on the host machine.
3. Install dependencies:
   1. `Cmd+Shift+P` and type "install remote development"
   2. Install plugins `Remote - Containers` and `Remote - SSH`.
4. Connect to the VM:
   1. `Cmd+Shift+P` and type "Remote-SSH: Connect to Remote Host"
   2. Pick `workbox` from the list.
5. Open workspace:
   1. `Cmd+Shift+P` and type "open workspace from file"
   2. Locate the file `/home/vagrant/projects/.vscode/workspace.code-workspace`
6. Install recomended extensions
   1. `Cmd+Shift+P` and type "Extensions: Show Recommended Extensions"
   2. Click on the little cloud symbol.

# Reasoning

There are various ways to code in this setup. I have outlined my decisions in a [thorough article](https://medium.com/homullus/docker-for-mac-performance-diy-d4m-e4232ca8b671).

This branch is used exclusively for "Container-First" approach.

### Container-first
| 	🛰	|	Files	|	Editor/Interpreter	|	Runtime	|
|	-	|	-		|	-					|	-		|
|	Host|			|						|			|
|	VM	|	🔻		|	🔻					|	🔻		|

Feeling adventurous? Don't use sharing at all. Provision the VM with your SSH key, and download your projects inside the VM. Use the rest the same as you would in the Remote Interpreter segment above. You will get an insane speed boost since you don't have any shared files between host and the VM - everything is only in VM.

## Remote coding How-tos
I have written an extensive [article on the topic](https://medium.com/homullus/remote-development-or-how-i-learned-to-stop-worrying-and-love-the-mainframe-90165147a57d), in short:
- VSCode has a built in "Attach to remote Container" capability. It spawns a real editor and you work directly with the native interpreter within the container.
- JetBrains "thick-ide" products like PHPStorm have a similar capability to be located on your host, but use a remote interpreter from within the container.

# Tips & Tricks

## Cleaning up from time to time
From time to time, the docker system will get clogged with an ungodly amount of leftover volumes and such. Instead of rebuilding the VM you can simply clean it up!
1. `docker system prune --all`
2. `docker volume rm $(docker volume ls)`
3. delete vendors
  ```bash
  find . -type d -name node_modules -prune -exec rm -rf {} \;
  find . -type d -name .venv -prune -exec rm -rf {} \;
  find . -type d -name .tmp -prune -exec rm -rf {} \;
  find . -type d -name .vscode-server -prune -exec rm -rf {} \;
  ```
5. `ncdu /`

## SSH config
When trying to add custom SSH key as *id_rsa* & *id_rsa.pub* and trying to connect it's possible that there'll be an error
saying that:
   ```bash
   Permissions (0777/0664 / or other) for '/$ser/$username/.ssh/id_rsa' are too open.
   It is recommended that your private key files are NOT accessible by others.
   This private key will be ignored.
   ``` 
That happend becouse of wrong .ssh folder and within files permission.
Fix bellow commands:
```bash
 chmod 0600 ~/.ssh/id_rsa.pub
 chmod 0600 ~/.ssh/authorized_keys
 chmod 0600 ~/.ssh/id_rsa
 chmod 0700 ~/.ssh
```