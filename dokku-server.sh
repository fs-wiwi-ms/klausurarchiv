apt update && apt upgrade -y

adduser tbho
usermod -aG sudo tbho

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

usermod -aG docker tbho

visudo
# Paste `tbho ALL=(ALL) NOPASSWD:ALL` at the end of the file

mkdir /home/tbho/.ssh

curl https://github.com/tbho.keys > /home/tbho/.ssh/authorized_keys

# restart ssh with tbho

wget https://raw.githubusercontent.com/dokku/dokku/v0.24.7/bootstrap.sh
sudo DOKKU_TAG=v0.24.7 bash bootstrap.sh

# call server adress and finish dokku install, leave hostname field unchecked
