#!/bin/bash
#SBATCH --job-name=tf_horovod_test
#SBATCH --output=output/tf_horovod_test_%j.txt
#SBATCH -N 16
#SBATCH --cpus-per-task=32
#SBATCH --time=00:20:00
#SBATCH --gres=gpu:8
#SBATCH --exclusive
#SBATCH --mem=0

# Install prefix -- where ever the conda env was made
# TODO: input variable?
INSTALL_PREFIX=$HOME/conda_tensorflow_2.9.1+cuda_11.4.4+horovod_0.25.0

# Needs to be big enough for decent scaling.
# Default is 32 and scaling is around 50%
BATCH_SIZE=256

# pull the test file from github
wget https://raw.githubusercontent.com/horovod/horovod/c7bc877c6f80399b715bee068b7846ef9d229c51/examples/tensorflow2/tensorflow2_synthetic_benchmark.py

module purge

. /hpc/mp/spack/share/spack/setup-env.sh
module load gcc-10.3.0-gcc-9.4.0-d44jwah
module load cuda-11.4.4-gcc-10.3.0-ctldo35
module load nccl-2.11.4-1-gcc-10.3.0-rvdzi4n
module load cudnn-8.2.4.15-11.4-gcc-10.3.0-eluwegp

module use /hpc/mp/modules/
module load hpcx/hpcx

eval "$(/hpc/mp/apps/conda/bin/conda shell.bash hook)"
conda activate $INSTALL_PREFIX

# These should be set at a system level, but make sure we use the right interfaces
export UCX_NET_DEVICES=mlx5_0:1,mlx5_1:1,mlx5_2:1,mlx5_3:1,mlx5_6:1,mlx5_7:1,mlx5_8:1,mlx5_9:1
export NCCL_IB_HCA=mlx5_0:1,mlx5_1:1,mlx5_2:1,mlx5_3:1,mlx5_6:1,mlx5_7:1,mlx5_8:1,mlx5_9:1
#export NCCL_DEBUG=INFO

# From Horovod Docs: https://horovod.readthedocs.io/en/stable/mpi_include.html
export HOROVOD_MPI_THREADS_DISABLE=1
#export OMPI_MCA_btl=^openib
#export OMPI_MCA_pml=ucx,ob1

# from https://github.com/google/jax/issues/7118
# trying to prevent cublas failures
# This may be needed for older code
# export XLA_PYTHON_CLIENT_PREALLOCATE=false
# export TF_FORCE_GPU_ALLOW_GROWTH=true

declare -a NUM_GPUS
declare -a IMAGS_PER_SEC
declare -a DEVIATION

for n_nodes in 1 2 4 8 16; do

  if [ $n_nodes -eq 1 ]; then
    for n_gpus in 1 2 4 8; do

      srun --cpu-bind=none -N $n_nodes --ntasks-per-node=$n_gpus --gres=gpu:$n_gpus python tensorflow2_synthetic_benchmark.py --batch-size $BATCH_SIZE 2>&1 | tee tmp.log
      last_line=$(tail -n1 tmp.log)
      if [[ "$last_line" =~ on[[:space:]]([[:digit:]]+)[[:space:]]GPU\(s\):[[:space:]]([[:digit:]]+.[[:digit:]]+)[[:space:]]\+\-([[:digit:]]+.[[:digit:]]+) ]]; then
        NUM_GPUS+=("${BASH_REMATCH[1]}")
        IMAGES_PER_SEC+=("${BASH_REMATCH[2]}")
        DEVIATION+=("${BASH_REMATCH[3]}")
      fi

    done
  else

    srun --cpu-bind=none -N $n_nodes --ntasks-per-node=8 --gres=gpu:8 python tensorflow2_synthetic_benchmark.py --batch-size $BATCH_SIZE 2>&1 | tee tmp.log
    last_line=$(tail -n1 tmp.log)
    if [[ "$last_line" =~ on[[:space:]]([[:digit:]]+)[[:space:]]GPU\(s\):[[:space:]]([[:digit:]]+.[[:digit:]]+)[[:space:]]\+\-([[:digit:]]+.[[:digit:]]+) ]]; then
      NUM_GPUS+=("${BASH_REMATCH[1]}")
      IMAGES_PER_SEC+=("${BASH_REMATCH[2]}")
      DEVIATION+=("${BASH_REMATCH[3]}")
    fi

  fi

# srun python tensorflow2_synthetic_benchmark.py --fp16-allreduce
done

touch output/scaling_$SLURM_JOB_ID.txt

length==$((${#NUM_GPUS[@]}-1))

for (( j=0; j<${length}; j++ ));
do
  echo "${NUM_GPUS[$j]}, ${IMAGES_PER_SEC[$j]}, ${DEVIATION[$j]}" >> output/scaling_$SLURM_JOB_ID.txt
done

# TODO: fixed path?
python ../common/graph_scaling.py output/scaling_$SLURM_JOB_ID.txt --title "Horovod TensorFlow Synthetic Test"

# delete tmp file and benchmark
rm tensorflow2_synthetic_benchmark.py
rm tmp.log
