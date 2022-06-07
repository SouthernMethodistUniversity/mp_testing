# MPI

## Download and install HPC-X:

```
cd /hpc/superpod/testing/nvidia
wget https://content.mellanox.com/hpc/hpc-x/v2.11/hpcx-v2.11-gcc-MLNX_OFED_LINUX-5-ubuntu20.04-cuda11-gdrcopy2-nccl2.11-x86_64.tbz
tar -xvf hpcx-v2.11-gcc-MLNX_OFED_LINUX-5-ubuntu20.04-cuda11-gdrcopy2-nccl2.11-x86_64.tbz
```

Then convert the ``hpcx_init.sh`` into a `lua` module. See [hpcx_init.lua](hpcx_init.lua). 
The conversion utility from lmod didn't do a complete job, so I just manually converted.

## Testing

The test is simple *hello world* program with an option to do a reduce operation. See the (src folder)[src].

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
