# Hosting

## Steps

1. Provision machine
1. `./install.sh root@<server>`
1. `ssh root@<server>`
1. `cd /root/klausurarchiv`

1. Copy source files to machine or use image registry
1. `docker build -t klausurarchiv .` or `docker login docker.pkg.github.com` and type in username and password
1. `docker-compose up -d`
