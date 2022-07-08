# MPI

## Download and install HPC-X:

```
cd /hpc/superpod/testing/nvidia
wget https://content.mellanox.com/hpc/hpc-x/v2.11/hpcx-v2.11-gcc-MLNX_OFED_LINUX-5-ubuntu20.04-cuda11-gdrcopy2-nccl2.11-x86_64.tbz
tar -xvf hpcx-v2.11-gcc-MLNX_OFED_LINUX-5-ubuntu20.04-cuda11-gdrcopy2-nccl2.11-x86_64.tbz
```

Then convert the ``hpcx-init.sh`` into a `lua` module. See [hpcx-init.lua](hpcx-init.lua). 
The conversion utility from lmod didn't do a complete job, so I just manually converted.

## Testing

The test is simple *hello world* program with an option to do a reduce operation. See the [src folder](src).

For a small number of tasks this program appears to work. For example,

```
export MODULEPATH=/hpc/superpod/testing/modules
module load mpi/hpcx-direct-install
make clean
make
srun --mpi=pmix -N 3 --ntasks-per-node=4 --cpus-per-task=1 -t 5 ./mpi_test
```

works as expected. However, increasing the number of tasks such as

```
export MODULEPATH=/hpc/superpod/testing/modules
module load mpi/hpcx-direct-install
make clean
make
export UCX_TLS=dc,self,sm,cma
export RX_QUEUE_LEN=8192
export IB_RX_QUEUE_LEN=8192
srun --mpi=pmix -N 3 --ntasks-per-node=64 --cpus-per-task=1 -t 5 ./mpi_test
```

fails.
Note that the extra exports are there to try to produce useful error logs, but
are not necessary to reproduce the errors.
An example of the errors can be seen in [mpi_errors.out](mpi_errors.out)

## Notes

The failures *might* be related to packet drops and configurations based on these github tickets:
- https://github.com/openucx/ucx/issues/6522
- https://github.com/openucx/ucx/issues/6000#issuecomment-747641976

# HPC-X via the Nvidia HPC Toolkit

Install the latest Nvidia HPC Toolkit (22.5) in the following way seems to work better than anything I've tried.

```
cd /hpc/superpod/testing/nvidia/
wget https://developer.download.nvidia.com/hpc-sdk/22.5/nvhpc_2022_225_Linux_x86_64_cuda_11.7.tar.gz
tar xpzf nvhpc_2022_225_Linux_x86_64_cuda_11.7.tar.gz
. /hpc/superpod/testing/spack/share/spack/setup-env.sh
module load gcc-10.3.0-gcc-9.4.0-5skxfbd 
NVHPC_SILENT=true NVHPC_INSTALL_DIR=/hpc/superpod/testing/nvidia/hpc_sdk_22.5 NVHPC_INSTALL_TYPE=single NVHPC_STDPAR_CUDACC=80 ./nvhpc_2022_225_Linux_x86_64_cuda_11.7/install
```

The default MPI (OpenMPI 3.1.5) produces lots of warnings. 
These appear to be related to the fact that this MPI does not have `ucx` and other components.
However, the installed version of HPC-X does seem to work.

This is accessible in the following way:

```
. /hpc/superpod/testing/spack/share/spack/setup-env.sh
module use /hpc/superpod/testing/nvidia/hpc_sdk_22.5/Linux_x86_64/22.5/comm_libs/hpcx/hpcx-2.11/modulefiles/
module use /hpc/superpod/testing/nvidia/hpc_sdk_22.5/modulefiles

module load gcc-10.3.0-gcc-9.4.0-5skxfbd
module load nvhpc/22.5
module load hpcx-ompi
```

** Note
It is also necessary to set 

```
export UCX_NET_DEVICES=mlx5_0:1,mlx5_1:1,mlx5_2:1,mlx5_3:1,mlx5_6:1,mlx5_7:1,mlx5_8:1,mlx5_9:1
```

which is likely in indication of a configuration error.
