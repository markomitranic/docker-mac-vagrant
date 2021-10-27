# Docker in Vagrant

D4M is slow. Primarily because of its osxfs/grpcfuse sharing filesystem. On the other hands Parallels has their own proprietary driver, and it works at almost native speeds.

- [Setting up](#setting-up)
- [Usage](#usage)
    - [👨‍🔧 Naked](#naked)
    - [👨‍⚕️ Remote Interpreter](#remote-interpreter)
    - [👨‍🚀 Container-first](#container-first)
- [Remote coding in VSCode and IntelliJ](#remote-coding)

## Setting up

1. Install and set up vagrant VM:
    ```bash
    brew install direnv
    brew install vagrant
    vagrant plugin install vagrant-parallels
    vagrant plugin install vagrant-env
    cp .env.dist .env
    ```
2. Set your preferred shared folder in the `.env` file, for example `SHARE_PATH="$HOME/Sites/"`
3. Thats it, start vagrant with `vagrant up`.
4. Add the following to VScode Settings:
    ```bash
    "docker.explorerRefreshInterval": 10000,
    "docker.host": "ssh://vagrant@workbox",
    ```
5. You can even set up a docker context. Works similarly to what you'd use `docker-machine` for:
    ```bash
    docker context create workbox --docker "host=ssh://vagrant@workbox"
    docker context use workbox
    ```


## Usage

There are various ways to code in this setup. I have outlined my decisions in a [thorough article](https://medium.com/homullus/docker-for-mac-performance-diy-d4m-e4232ca8b671).

### Naked
You can just go oldschool and keep coding on your local machine. Use your editor of choice. All the files will be sync-ed over to the containers at nearly native speeds.

You will need however, to have the language you use installed on your machine, if you hope to have intellisense.

### Remote Interpreter
A better (albeit weird at first) way would be to share the code from your machine to the Parallels VM. Start containers. Refer to [Remote Interpreter](#remote-coding) section for directions on how to use the editors.

### Container-first
Feeling adventurous? Don't use sharing at all. Provision the VM with your SSH key, and download your projects. Start containers. Refer to [Remote Interpreter](#remote-coding) section for directions on how to use the editors.

## Remote coding How-tos
I have written an extensive [article on the topic](https://medium.com/homullus/remote-development-or-how-i-learned-to-stop-worrying-and-love-the-mainframe-90165147a57d), in short:
- VSCode has a built in "Attach to remote Container" capability. It spawns a real editor and you work directly with the native interpreter within the container.
- JetBrains "thick-ide" products like PHPStorm have a similar capability to be located on your host, but use a remote interpreter from within the container.
