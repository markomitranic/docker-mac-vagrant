#!/bin/sh
set -e

BOX_NAME=$1

if [ -z "$BOX_NAME" ]; then
    echo "You must pass BOX_NAME as the first argument. Exiting..."
    exit 1
fi

docker context use default

if docker context inspect "$BOX_NAME" > /dev/null; then
    docker context rm "$BOX_NAME" || true
fi

rm -f "$HOME/.ssh/config.d/${BOX_NAME}"
