#!/usr/bin/env zsh

# Docker image tag
tag="mpi:hostnames"

# Enroot image filename from Docker image tag
sqsh=${tag//:/_}.sqsh

# Build using Docker
docker build -t ${tag}

# Convert from local Docker daemon using enroot
sudo enroot import -o ${sqsh} dockerd://${tag}
sudo chown $USER:$USER ${sqsh}

