# Quick Overview:

**All code in this repo is for testing. The code may not work and may change. Pull requests and issues welcome.**

## MPI:

MPI (HPC-X) is available as a module. 

```
module use /hpc/mp/modules/
module load hpcx
```

It is sometimes necessary to set the network interfaces (we're investigating):

```
export UCX_NET_DEVICES=mlx5_0:1,mlx5_1:1,mlx5_2:1,mlx5_3:1,mlx5_6:1,mlx5_7:1,mlx5_8:1,mlx5_9:1
```

### Related Testing Notes and Scripts

- [02_nvhpc+nccl](testing/02_nvhpc+nccl) Nvidia NCCL tests with MPI enabled
- [06_mpi](testing/06_mpi) Notes about (mostly) failed installs of MPI
- [09_container_mpi](testing/09_container_mpi) MPI in a container

## Spack Installs:

We are currently using Spack to install most software stacks.
This software is available though the module system after calling

```
. /hpc/mp/spack/share/spack/setup-env.sh 
```

### Related Testing Notes and Scripts

- [01_spack](testing/01_spack) LAMMPS and NVHPC as Spack environments
- [05_openmm](testing/05_openmm) OpenMM via Spack environmnet
- [08_pytorch](testing/08_pytorch) PyTorch via Spack environment
- [07_Magma+RAJA_via_spack](testing/07_Magma+RAJA_via_spack) RAJA and Magma install and tests from Spack

## Conda:

Especially for testing, we recommend that you install Miniconda
locally (https://docs.conda.io/en/latest/miniconda.html.) 

Packages that highly configuration depenendent, e.g. ``mpi4py``
should be installed with `pip`, e.g.

```
MPI-X MPI
module use /hpc/mp/modules/
module load hpcx

# GCC 10.3 from spack
. /hpc/mp/spack/share/spack/setup-env.sh
module load gcc-10.3.0-gcc-9.4.0-d44jwah

# load a Conda Environment
conda activate <your environment name or path>

# install mpi4py with system MPI compiler
export MPICC=$(which mpicc)
pip install --no-binary :all: --compile mpi4py
```

We currently have a system version available using the following:

```
eval "$(/hpc/mp/apps/conda/bin/conda shell.bash hook)"
```

If you are using the system version and get permission issues, 
they may be fixed by adding the following to your $HOME/.condarc

```
envs_dirs:
  - $HOME/.conda/envs
pkgs_dirs:
  - $HOME/.conda/pkgs
```

### Related Testing Notes and Scripts

- [10_conda](testing/10_conda) Example setup of Conda environments with PyTorch and TensorFlow, both with Horovod.

## Storage and M2 Access

You should be able to copy files to and from M2. 
M2 is visible from the SuperPod, but the SuperPod is not currently
visible from M2.
Note that the systems are different, so you should not 
depend on anything built on one machine working on the
other.

M2 home directory from SuperPod: `$M2HOME`

`$WORK` is shared and the same space on both systems

`$SCRATCH` and local disk space on the SuperPod is 
subject to purging (policy TBD --- likely to automatically 
purge data older than 30 days and enforce space quotas.)

