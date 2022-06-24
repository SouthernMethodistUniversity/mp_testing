#!/bin/bash

# Install prefix
# TODO: good naming convention?
# TODO: input variable for this?
INSTALL_PREFIX=$HOME/conda_tensorflow_2.9.1+cuda_11.4.4+horovod_0.25.0

# NOTE: The following where installed via Spack:
# spack install cudnn%gcc@10.3.0 ^cuda@11.4.4
# spack install nccl%gcc@10.3.0 +cuda cuda_arch=80 ^cuda@11.4.4

# Load spack dependencies
. /hpc/mp/spack/share/spack/setup-env.sh
module load gcc-10.3.0-gcc-9.4.0-d44jwah
module load cuda-11.4.4-gcc-10.3.0-ctldo35
module load nccl-2.11.4-1-gcc-10.3.0-rvdzi4n
module load cudnn-8.2.4.15-11.4-gcc-10.3.0-eluwegp
module load cmake-3.23.1-gcc-10.3.0-faucxp3

# MPI
module use /hpc/mp/modules/
module load hpcx/hpcx

# Conda
eval "$(/hpc/mp/apps/conda/bin/conda shell.bash hook)"

# make sure Conda uses a local path
CONDA_PREFIX=$HOME/.conda

# Set environment variables that get used in building
export MPICC=$(which mpicc)
export MPICXX=$(which mpicxx)
export HOROVOD_CUDA_HOME=$CUDA_HOME
# TODO: Should the nccl module set NCCL_HOME? (from Spack)
export HOROVOD_NCCL_HOME=/hpc/mp/spack/opt/spack/linux-ubuntu20.04-zen2/gcc-10.3.0/nccl-2.11.4-1-rvdzi4nkhtxqj3gpbpfznchcwedbctth
export HOROVOD_BUILD_CUDA_CC_LIST=80
export HOROVOD_GPU_OPERATIONS=NCCL
export HOROVOD_WITH_MPI=1

# create the Conda environment.
# Note: pip installs are not done by a requirements.txt as usual
# this is to ensure the builds happen in the correct order and
# make use of system libraries where that is beneficial
#
# TODO: fixed paths?
conda env create --prefix $INSTALL_PREFIX --file ../common/environment.yml --force

# activate the new environment
conda activate $INSTALL_PREFIX

# install pip packages
pip install --no-binary :all: --compile mpi4py
pip install tensorflow==2.9.1
pip install pip install --no-cache-dir horovod==0.25.*

# Run horovod install check
horovodrun --check-build
