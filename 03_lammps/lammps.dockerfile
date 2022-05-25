FROM nvcr.io/nvidia/nvhpc:22.3-devel-cuda_multi-ubuntu20.04
WORKDIR /build
RUN git clone -b patch_4May2022 https://github.com/lammps/lammps.git

