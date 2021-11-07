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
    echo "Adding 'Include config.d/*' to '$HOME/.ssh/config' file..."

    # Define newline. OSX sed does not know how to interpret \n
    # character. This must be spread over two lines and must not
    # include spaces!
    nl='
'
    # Prepend content to the start of the file
    sed -i'.bak' -e '1s;^;Include config.d/*'"\\${nl}\\${nl}"';' "$HOME/.ssh/config"
    unset nl
else
    echo "No need to modify '$HOME/.ssh/config'. Continuing..."
fi

ssh-keyscan -H "$BOX_NAME" >> "$HOME/.ssh/known_hosts"

docker context create "$BOX_NAME" --docker "host=ssh://vagrant@${BOX_NAME}" || true
docker context use "$BOX_NAME" || true

echo "Testing Docker connectivity..."
docker ps
