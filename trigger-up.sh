#!/bin/sh

set -e

BOX_NAME=$1

if [ -z "$BOX_NAME" ]; then
    echo "You must pass BOX_NAME as the first argument. Exiting..."
    exit 1
fi

mkdir -p "$HOME/.ssh/config.d"

# Read up-to-date SSH configuration for the $BOX_NAME from Vagrant
vagrant ssh-config "$BOX_NAME" > "$HOME/.ssh/config.d/${BOX_NAME}"

# Hack: if grep does not match anything, it will exit with code 1.
# Hence we add || true, to force exit code to 0 regardless of match.
SSH_CONFIG_HAS_INCLUDE_D="$(grep -i 'Include config.d/*' "$HOME/.ssh/config" || true )"

if [ -z "$SSH_CONFIG_HAS_INCLUDE_D" ]; then
    echo "Backup $HOME/.ssh/config"
    cp $HOME/.ssh/config $HOME/.ssh/config.bak
    echo "Adding 'Include config.d/*' to '$HOME/.ssh/config' file..."
    printf '%s\n%s\n' "Include config.d/*" "" "$(cat $HOME/.ssh/config)" > $HOME/.ssh/config
else
    echo "No need to modify '$HOME/.ssh/config'. Continuing..."
fi

HOSTS_HAS_BOX_NAME="$(grep -i $BOX_NAME "/etc/hosts" || true )"

if [ -z "$HOSTS_HAS_BOX_NAME" ]; then
    echo "Backup /etc/hosts"
    sudo cp /etc/hosts /etc/hosts.bak 
    echo "Adding '$BOX_NAME' to /etc/hosts file on local loopback"
    sudo bash -c "echo '127.0.0.1 $BOX_NAME' >> /etc/hosts"
else
    echo "No need to modify '/etc/hosts'. Continuing..."
fi

ssh-keyscan -H "$BOX_NAME" >> ~/.ssh/known_hosts

docker context create "$BOX_NAME" --docker "host=ssh://vagrant@${BOX_NAME}" || true
docker context use "$BOX_NAME" || true

echo "Testing Docker connectivity..."
docker ps
