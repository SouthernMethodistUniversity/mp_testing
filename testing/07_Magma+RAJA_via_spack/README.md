# RAJA and Magma via Spack

## Spack setup

```
git clone -c feature.manyFiles=true https://github.com/spack/spack.git
cd spack
git checkout releases/v0.18 
```

## Software install

```
spack install gcc@10.3.0
spack load gcc-10.3.0-gcc-9.4.0-5skxfbd 
spack compiler find
spack install magma%gcc@10.3.0 +cuda cuda_arch=80 ^cuda@11.4
spack install raja%gcc@10.3.0 +cuda +tests cuda_arch=80 ^cuda@11.4
spack module lmod refresh
```

### Install Notes:

- I deleted all references to `/tmp/appmgr/spack-stage/...` from the `pkgconfig`
  of Magma. This appears to be a build error as they are build time paths and not
  relavent for the install. I have opened a [ticket with Spack](https://github.com/spack/spack/issues/31002)
  even though it is not really a Spack problem. 
  Possibily related https://bitbucket.org/icl/magma/issues/52/issues-with-pkgconfig-file-using-spack
- I do not understand why the lmod refresh is needed, but commands like 

  ```spack module lmod loads --dependencies magma```

  fail without it. However, the modules that are returned appear to be incorrectly
  named, so commands like

  ```source <( spack module lmod loads --dependencies magma)```

  fail. It tries to load modules like `pkgconf/1.8.0-sqesdme` but the module name is `pkgconf-1.8.0-gcc-10.3.0-sqesdm`.

## Magma Testing

Clone the Magma repository from here https://bitbucket.org/icl/magma/src/master/

From `magma/example` the examples can be run like (note ``tcl loads`` works, but ``lmod loads`` does not):

```
srun --cpus-per-task=32 -t 00:10:00 --gres=gpu:1 --pty bash
module load gcc-10.3.0-gcc-9.4.0-5skxfbd 
source <( spack module tcl loads --dependencies magma)
make all

# run an example, e.g.
./example_f
```

## RAJA Testing

Clone the RAJAPerf suite:

```
git clone --recursive https://github.com/llnl/RAJAPerf.git
cd RAJAPerf/
git checkout develop
git submodule update --recursive
```

Load modules for building

```
# for HPC-X MPI Bundled with NVHPC (currently the best working MPI)
module use /hpc/superpod/testing/nvidia/hpc_sdk_22.5/Linux_x86_64/22.5/comm_libs/hpcx/hpcx-2.11/modulefiles/
# for Spack installs
. /hpc/superpod/testing/spack/share/spack/setup-env.sh
module load gcc-10.3.0-gcc-9.4.0-5skxfbd 
source <( spack module tcl loads --dependencies raja)
module load hpcx 
```

Configure and build:

```
mkdir build
cd build
cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DMPI_CXX_COMPILER=$(which mpic++) \
  -DCMAKE_CXX_COMPILER=$(which g++) \
  -DBLT_CXX_STD=c++14 \
  -DENABLE_MPI=On \
  -DENABLE_OPENMP=On \
  -DENABLE_CUDA=On \
  -DCUDA_ARCH=sm_80 \
  -DCMAKE_CUDA_ARCHITECTURES=80 \
  ..
make -j
```

### Running

The test can be run like 

```
# Make sure MPI uses the correct interfaces. (this should be fixed at a system level at some point)
export UCX_NET_DEVICES=mlx5_0:1,mlx5_1:1,mlx5_2:1,mlx5_3:1,mlx5_6:1,mlx5_7:1,mlx5_8:1,mlx5_9:1

# run
srun -N 2 --ntasks-per-node=8 --cpus-per-task=16 --gres=gpu:8 ./bin/raja-perf.exe -sp -ek Basic_INDEXLIST
```

A sample of the results can be seen in the [sample_results](sample_results) folder.

I have exclude the `Basic_INDEXLIST` test above. 
The Base_CUDA tests hang on it (I didn't investigate, but it runs fine on a single task.)
