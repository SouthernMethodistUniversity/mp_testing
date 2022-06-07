#!/bin/bash
#SBATCH -J lammps                      # Job name
#SBATCH -o lammps_%j.out               # Output file name
#SBATCH -p batch                       # Partition (queue)
#SBATCH -N 1                           # Number of nodes
#SBATCH -n 1                           # Number of tasks
#SBATCH -c 1                           # Number of cores per task
#SBATCH -w bcm-dgxa100-0020

enroot start ./lammps_20210310_cpu.sqsh \
lmp\
 -var x 8 -var y 4 -var z 8\
 -in lammps.in

