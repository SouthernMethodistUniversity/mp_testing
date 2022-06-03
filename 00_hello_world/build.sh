#!/usr/bin/env zsh

# Build using Docker
docker build -t nvhpc_hello:latest -f ./hello_world.dockerfile .

# Convert from local Docker daemon using enroot
sudo enroot import -o hello_world.sqsh dockerd://nvhpc_hello:latest
sudo chown $USER:$USER hello_world.sqsh

# Run image using enroot
enroot start hello_world.sqsh

