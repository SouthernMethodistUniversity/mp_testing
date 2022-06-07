#!/usr/bin/env zsh


enroot pull 'nvcr.io#nvidia/pytorch:22.04-py3'
enroot convert pytorch_latest.sqsh
srun -n1 -G2 --container-image pytorch_latest.sqsh --container-mounts=$HOME:/workspace --pty bash -i

