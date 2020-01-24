#!/usr/bin/env bash
set -euo pipefail

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

sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot

sudo apt-get update

sudo apt-get install -y \
    docker-ce \
    docker-compose \
    nginx \
    certbot

sudo service nginx stop

sudo certbot certonly --standalone -d klausurarchiv.fachschaft-wiwi.ms --agree-tos -m tbho@tbho.de

sudo service nginx start

(crontab -l 2>/dev/null; echo "0 3 * * 2,5 certbot renew --force-renewal --standalone --pre-hook 'service nginx stop' --post-hook 'service nginx start'") | crontab -
