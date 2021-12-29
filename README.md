# Docker in Vagrant

This repository automates the provisioning of a Vagrant VM that acts as a hypervisor. In other words, it effortlessly replaces the slow parts of Docker for Mac. Your code runs faster, battery lasts longer and fans spin less - and you don't have to change anything about your projects.

[D4M is slow](https://medium.com/homullus/docker-for-mac-performance-diy-d4m-e4232ca8b671). Primarily because of its osxfs/grpcfuse sharing filesystem. On the other hand, Parallels has their own proprietary fs sharing driver, and it works at almost native speeds. Unfortunately for us all, Vbox and VMWare do not seem to have the same performance.

- [Setting up](#setting-up)
- [Usage](#usage)
    - [👨‍🔧 Naked](#naked)
    - [👨‍⚕️ Remote Interpreter](#remote-interpreter)
    - [👨‍🚀 Container-first](#container-first)
- [Remote coding in VSCode and IntelliJ](#remote-coding)

## Setting up

1. Install and set up vagrant VM:
    ```bash
    ./setup.sh
    ```
2. Set your preferred shared folder in the `.env` file, for example `SHARE_PATH="$HOME/Sites/"`
3. Thats it, start vagrant with `vagrant up`.
4. Add the following to VScode Settings:
    ```bash
    "docker.explorerRefreshInterval": 10000,
    "docker.host": "ssh://vagrant@workbox",
    ```

## Usage

There are various ways to code in this setup. I have outlined my decisions in a [thorough article](https://medium.com/homullus/docker-for-mac-performance-diy-d4m-e4232ca8b671).

### Naked
| 	😪	|	Files	|	Editor/Interpreter	|	Runtime	|
|	-	|	-		|	-					|	-		|
|	Host|	🔻		|	🔻					|			|
|	VM	|	🔻		|						|	🔻		|

You can just go oldschool and keep coding on your local machine. Use your editor of choice. All the files will be sync-ed over to the containers at nearly native speeds. In other words, you run your Docker project as you usually would.

**Reminder:** You will need however, to have the language you use installed on your machine, if you hope to have intellisense.

### Remote Interpreter
| 	💿	|	Files	|	Editor/Interpreter	|	Runtime	|
|	-	|	-		|	-					|	-		|
|	Host|	🔻		|						|			|
|	VM	|	🔻		|	🔻					|	🔻		|

A better (albeit weird at first) way would be to share the code from your machine to the Parallels VM. Start containers. Refer to [Remote coding How-tos](#remote-coding-how-tos) section for directions on how to use the editors.

**Here's an example** - Host computer has no idea what Python is. I start the Docker container with Python inside. I click a button in VSCode, and it magically "teleports" itself into the container. You can now literally code within the container, without ever leaving the comfort of your editor. Of course, the files are on a volume so any changes you make are safely in sync with your local folder.

### Container-first
| 	🛰	|	Files	|	Editor/Interpreter	|	Runtime	|
|	-	|	-		|	-					|	-		|
|	Host|			|						|			|
|	VM	|	🔻		|	🔻					|	🔻		|

**Important: Use [`container-first`](https://github.com/markomitranic/docker-mac-vagrant/tree/container-first) Branch!**

Feeling adventurous? Don't use sharing at all. Provision the VM with your SSH key, and download your projects inside the VM. Use the rest the same as you would in the Remote Interpreter segment above. You will get an insane speed boost since you don't have any shared files between host and the VM - everything is only in VM.

## Remote coding How-tos
I have written an extensive [article on the topic](https://medium.com/homullus/remote-development-or-how-i-learned-to-stop-worrying-and-love-the-mainframe-90165147a57d), in short:
- VSCode has a built in "Attach to remote Container" capability. It spawns a real editor and you work directly with the native interpreter within the container.
- JetBrains "thick-ide" products like PHPStorm have a similar capability to be located on your host, but use a remote interpreter from within the container.
