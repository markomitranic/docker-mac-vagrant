#!/bin/sh

brew install vagrant
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-env

if [ ! -f .env ]; then
    cp .env.dist .env
fi

echo
echo '>> Contents of your .env file:'
echo

cat .env

echo
echo '>> Please review variables defined in .env file shown above.'
echo '>> If you need to make any adjustments, edit .env file now!'
echo '>> For example, you might want to adjust SHARE_PATH to where'
echo '>> your work directory resides.'
