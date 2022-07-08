#!/usr/bin/env zsh

# Symlink for spack.yaml
ln -s spack_lammps.yaml spack.yaml

# Generate Dockerfile
spack containerize > Dockerfile

# Build using Docker
docker build -t lammps_spack:20210310 .

# Convert from local Docker daemon using enroot
sudo enroot import -o lammps_20210310_cpu.sqsh dockerd://lammps_spack:20210310
sudo chown $USER:$USER lammps_20210310_cpu.sqsh

# Run image using enroot
enroot start lammps_20210310_cpu.sqsh

