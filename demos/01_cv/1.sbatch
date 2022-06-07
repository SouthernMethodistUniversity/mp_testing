#!/usr/bin/env zsh
#SBATCH -J cv_1
#SBATCH -o cv_1_%j.out
#SBATCH -c 4
#SBATCH --mem=16G

# Preprocess the data
# Flags:
# --no-container-remap-root : Set actual user inside container (not root)
# --container-image         : Source container image
# --container-save          : Destination container image
# --no-container-entrypoint : Do not use image entrypoint
# --container-mounts        : Mount NeMo repo as workspace inside container
# bash -l -c ./reinstall.sh : Run the NeMo reinstall.sh script path already
#                             in NeMo directory due to --container-mounts

srun\
 --no-container-remap-root\
 --container-image nvcr.io#nvidia/tensorflow:22.02-tf2-py3\
 --no-container-entrypoint\
 --container-mounts ${WORK}/imagenet:/imagenet\
 --container-workdir /workspace/nvidia-examples/build_imagenet_data\
 bash -c '/workspace/nvidia-examples/build_imagenet_data/download_and_preprocess_imagenet.sh /imagenet'

