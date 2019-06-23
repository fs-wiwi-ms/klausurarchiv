#!/usr/bin/env bash
set -euo pipefail

export GIT_PUSH_USER="git"
export APP_NAME="klausurarchiv"

# install ssh keys for user 'pi'
mkdir -p ~/.ssh
cat ./ssh-keys > ~/.ssh/authorized_keys

# upgrade system
sudo apt-get update
sudo apt-get -y upgrade


sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg2 \
    curl \
    git

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install -y \
    docker-ce \
    docker-compose \
    nginx \
    certbot

sudo service nginx stop

sudo certbot certonly --standalone -d klausurarchiv.fachschaft-wiwi.ms --agree-tos -m tbho@tbho.de

sudo service nginx start

# add ${GIT_PUSH_USER} user
sudo useradd -m -s /usr/bin/git-shell ${GIT_PUSH_USER} || true

# allow git push with ssh key
sudo su -l -s /bin/bash -c "mkdir -p ~/.ssh" ${GIT_PUSH_USER}
cat ./ssh-keys | sudo su -l -s /bin/bash -c 'cat > ~/.ssh/authorized_keys' ${GIT_PUSH_USER}

# allow docker usage for ${GIT_PUSH_USER}
sudo usermod -aG docker ${GIT_PUSH_USER}

# initialize git repo
sudo su -l -s /bin/bash -c "mkdir -p ~/${APP_NAME}; git init --bare ~/${APP_NAME}/" ${GIT_PUSH_USER}

# install post-receive hook
cat ./post-receive | sudo su -l -s /bin/bash -c "cat > /home/${GIT_PUSH_USER}/${APP_NAME}/hooks/post-receive" ${GIT_PUSH_USER}
sudo chmod +x /home/${GIT_PUSH_USER}/${APP_NAME}/hooks/post-receive

