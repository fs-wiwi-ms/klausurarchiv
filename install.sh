#!/usr/bin/env bash
set -euo pipefail

scp -r setup/ $1: && ssh $1 "cd ~/setup; chmod +x setup.sh; ./setup.sh"
scp nginx/nginx.conf $1:/etc/nginx/sites-available/default && ssh $1 "sudo service nginx restart"
