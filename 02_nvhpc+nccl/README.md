# NCCL testing

Clone the git repo from https://github.com/NVIDIA/nccl-tests

## Building with install on Metal

See [NVHPC install notes](nvhpc_install.md)

In newer versions of Cuda, the math libs are split out so the Makefile needs to be modified to find them.

Before this line (https://github.com/NVIDIA/nccl-tests/blob/master/src/Makefile#L72) add

```
NVLDFLAGS += -L/hpc/superpod/testing/nvidia/hpc_sdk_22.3/Linux_x86_64/22.3/math_libs/lib64
```

This allows the build to find the `curand` library.

Build with 

```
export MODULEPATH=/hpc/superpod/testing/modules
module load hpc_sdk_22.3
make MPI=1 CUDA_HOME=/hpc/superpod/testing/nvidia/hpc_sdk_22.3/Linux_x86_64/22.3/cuda/11.6/ NCCL_HOME=/hpc/superpod/testing/nvidia/hpc_sdk_22.3/Linux_x86_64/22.3/comm_libs/nccl/
```

## Building with a container

Again, modify the Makefile for for the Cuda math libs by adding 

```
NVLDFLAGS += -L/opt/nvidia/hpc_sdk/Linux_x86_64/22.3/math_libs/11.6/lib64
```

before this line (https://github.com/NVIDIA/nccl-tests/blob/master/src/Makefile#L72).

Launch the container, e.g. with (GPUs not necessary unless you want to test in the session)

```
srun -w bcm-dgxa100-0020 -t 60:00 --gres=gpu:8 --container-image="nvcr.io#nvidia/nvhpc:22.3-devel-cuda_multi-ubuntu20.04" --pty bash
```

Build with

```
make MPI=1 CUDA_HOME=/opt/nvidia/hpc_sdk/Linux_x86_64/22.3/cuda/11.6/ NCCL_HOME=/opt/nvidia/hpc_sdk/Linux_x86_64/22.3/comm_libs/nccl
```

## Running

Jobs where run using the `container_job.sbatch` and `metal_job.sbatch` scripts. 

Note, the container job produces many warnings/errors about invalid interface names and that it can't find the NUMA libs, but it seems to work fine.

## Results

The results reported here take the `in-place` bus bandwidth results for the largest size run.

| Metal (GB/s) | Container (GB/s) |
|--------------|------------------|
| 185.05	   | 152.86           |
| 172.15	   | 185.83           |
| 150.60	   | 188.04           |
| 164.18	   | 188.88           |
| 181.06	   | 175.51           |
| 182.51	   | 171.01           |
| 170.77	   | 169.95           |
| 159.39	   | 173.57           |
| 152.94	   | 150.51           |
| 167.46	   | 173.84           |

|            | Metal (GB/s) | Container (GB/s) |
|------------|--------------|------------------|
|**min**     |  150.60      | 150.51           |
|**max**     |  185.05      | 188.88           |
|**mean**    |  168.61      | 173              |
|**std dev** |  12.07       | 13.22            |

### NOTE:

These represent results using 1 GPU per task (160 total tasks). Running 20 tasks instead with 8 GPUs each results in poorer performance and I'm not sure why. 