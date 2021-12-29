#!/bin/sh

sudo apt-get install -y unzip git ncdu

# Install docker-compose
# https://docs.docker.com/compose/install/#install-compose-on-linux-systems
curl -L "https://github.com/docker/compose/releases/download/2.2.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install kubectl 
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux
curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl
ln -s /usr/local/bin/kubectl /usr/bin/kubectl

# Install k9s 
# https://github.com/derailed/k9s
curl -L "https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz" -o /usr/local/bin/k9s
chmod +x /usr/local/bin/k9s
ln -s /usr/local/bin/k9s /usr/bin/k9s

# Install aws
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
curl -L "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --update
rm -rf ./aws ./awscliv2.zip

# Install aws-iam-authenticator
# https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
curl -L "https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator" -o /usr/local/bin/aws-iam-authenticator
chmod +x /usr/local/bin/aws-iam-authenticator
ln -s /usr/local/bin/aws-iam-authenticator /usr/bin/aws-iam-authenticator

# Expand File Watchers so VSCode can breathe
# https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
if ! grep -q "fs.inotify.max_user_watches=524288" "/etc/sysctl.conf" ; then
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
fi