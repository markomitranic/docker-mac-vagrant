#!/bin/sh

brew install vagrant
vagrant plugin install vagrant-parallels
vagrant plugin install vagrant-env
vagrant plugin install vagrant-hostmanager

if [ ! -f /etc/sudoers.d/vagrant_hostmanager ]; then
    echo
    echo '>> This script will create /etc/sudoers.d/vagrant_hostmanager file in order'
    echo '>> to allow vagrant-hostmanager plugin to do its job.'
    echo '>> You will also see the contents of the vagrant_hostmanager file.'
    echo

    sudo tee /etc/sudoers.d/vagrant_hostmanager <<-EOF
    Cmnd_Alias VAGRANT_HOSTMANAGER_UPDATE = /bin/cp ${HOME}/.vagrant.d/tmp/hosts.local /etc/hosts
    %admin ALL=(root) NOPASSWD: VAGRANT_HOSTMANAGER_UPDATE
EOF
fi

if [ ! -f .env ]; then
    cp .env.dist .env
fi

echo
echo 'Contents of your .env file:'

cat .env

echo
echo 'Please review variables defined in .env file shown above.'
echo 'If you need to make any adjustments, edit .env file now!'
echo 'For example, you might want to adjust SHARE_PATH to where'
echo 'your work directory resides.'
