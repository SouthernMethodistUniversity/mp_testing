
# nvhpc

mkdir ~/testing/nvidia
cd ~/testing/nvidia

## download multi-cuda version (10.2, 11.0, 11.6)

wget https://developer.download.nvidia.com/hpc-sdk/22.3/nvhpc_2022_223_Linux_x86_64_cuda_multi.tar.gz
tar xpzf nvhpc_2022_223_Linux_x86_64_cuda_multi.tar.gz

## set install options

```
export NVHPC_SILENT=true
export NVHPC_INSTALL_DIR=/hpc/superpod/testing/nvidia/hpc_sdk_22.3
export NVHPC_INSTALL_TYPE=single
export NVHPC_DEFAULT_CUDA=11.0
```

## install

./nvhpc_2022_223_Linux_x86_64_cuda_multi/install

## create LMOD modules

I just took the contents of `/hpc/superpod/testing/nvidia/hpc_sdk_22.3/modulefiles/nvhpc/22.3` and `/hpc/superpod/testing/nvidia/hpc_sdk_22.3/Linux_x86_64/22.3/comm_libs/hpcx/hpcx-2.10/modulefiles/hpcx` and cleaned up the formating a bit. These could be better, but they're fine for testing.

### NOTE

The `depends_on` command in the module file does not seem to work. So I am loading the `hpcx` module directly from the `nvhpc` module.

The toolkit comes bundled with 3 versions of MPI: `openmpi 3.1.5`, `openmpi 4.05`, and `openmpi 4.1.2rc4` (via `hpcx 2.10`). 
The "default" `openmpi 3.1.5` seems to work, but there are lots of warnings. 
I have not been able to get `openmpi 4.0.5` to work.
`openmpi 4.1.2rc4 / hpcx 2.10` seems to work the best and correctly gets the network interface ids.