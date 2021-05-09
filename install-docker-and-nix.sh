#!/bin/sh

# Install make
sudo apt update
sudo apt install make

# Setup nix
sudo mkdir /nix
sudo chown ubuntu /nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# Setup Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ${USER}
