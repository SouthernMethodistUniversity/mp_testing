#!/bin/bash
#
#SBATCH --job-name=nccl_test
#SBATCH --output=container_test_%j.txt
#SBATCH -N 20
#SBATCH --ntasks-per-node=8
#SBATCH --time=20:00
#SBATCH --gres=gpu:8
#SBATCH --exclusive

srun --cpu-bind=none --mpi=pmix_v3 --container-image="nvcr.io#nvidia/nvhpc:22.3-devel-cuda_multi-ubuntu20.04" --container-mounts "/users/jlagrone"  /users/jlagrone/repos/nccl-tests/build/all_reduce_perf -b 8 -e 8G -f 2 -g 1 -d double