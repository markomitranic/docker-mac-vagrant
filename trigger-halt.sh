#!/bin/sh
set -e

BOX_NAME=$1

if [ -z "$BOX_NAME" ]; then
    echo "You must pass BOX_NAME as the first argument. Exiting..."
    exit 1
fi

VAGRANT_BOX_IP=$(grep -i HostName "~/.ssh/config.d/${BOX_NAME}" | awk '{print $NF}' || true)

docker context use default

if docker context inspect "$BOX_NAME" > /dev/null; then
    docker context rm "$BOX_NAME" || true
fi

ssh-keygen -R "$BOX_NAME" || true
if [ ! -z "$VAGRANT_BOX_IP" ]; then
    ssh-keygen -R "$VAGRANT_BOX_IP"
fi

rm -f "$HOME/.ssh/config.d/${BOX_NAME}"
