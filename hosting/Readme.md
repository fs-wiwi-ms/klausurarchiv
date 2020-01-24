# Hosting

## Steps

1. Provision machine
1. `./install.sh root@<server>`
1. `ssh root@<server>`
1. `cd /root/klausurarchiv`
1. `docker login docker.pkg.github.com`
    - type in username and password
1. `docker-compose up -d`
