#!/bin/bash
#
#SBATCH --job-name=nccl_test
#SBATCH --output=metal_test_%j.txt
#SBATCH -N 20
#SBATCH --ntasks-per-node=8
#SBATCH --time=20:00
#SBATCH --gres=gpu:8
#SBATCH --exclusive

export MODULEPATH=/hpc/superpod/testing/modules

module purge
module load nvhpc_sdk/22.3

srun --mpi=pmix_v3 --cpu-bind=none /users/jlagrone/repos/nccl-tests/build/all_reduce_perf -b 8 -e 8G -f 2 -g 1 -d double
