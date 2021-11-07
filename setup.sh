#!/bin/sh

brew install vagrant
vagrant plugin install vagrant-parallels
vagrant plugin install vagrant-env

if [ ! -f .env ]; then
    cp .env.dist .env
fi

source .env

if [ ! -d "$SHARE_PATH" ]; then
    mkdir -p "$SHARE_PATH"
fi
