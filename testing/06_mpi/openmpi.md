# Open MPI Direct Install

We've been attempting to install Open MPI with the following:


## Sources and basic environment setup
```
# Download latest UCC, UCX, and OpenMPI
wget https://github.com/openucx/ucc/archive/refs/tags/v1.0.0.tar.gz
wget https://github.com/openucx/ucx/archive/refs/tags/v1.13.0-rc1.tar.gz
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.gz

mv v1.0.0.tar.gz ucc-1.0.0.tar.gz
mv v1.13.0-rc1.tar.gz ucx-1.13.0-rc1.tar.gz

tar xfp ucc-1.0.0.tar.gz
tar xfp ucx-1.13.0-rc1.tar.gz
tar xfp openmpi-4.1.4.tar.gz

# source modules
module use /hpc/superpod/testing/modules
. /hpc/superpod/testing/spack/share/spack/setup-env.sh

# use a Spack installed compiler. The system ones should be fine
# but I was having issues with the versions varying from compute
# and login nodes
module load gcc-10.3.0-gcc-9.4.0-5skxfbd 

# not sure this is needed? I got linking errors without it at one point
module load libiberty-2.37-gcc-10.3.0-v3wdplw

# set some paths for the install locations
export INSTALL_LOC=/hpc/superpod/testing/mpi/openmpi/ompi-4.1.4_gcc-10.3.0
export UCX_INSTALL_PATH=${INSTALL_LOC}/ucx
export UCC_INSTALL_PATH=${INSTALL_LOC}/ucc

# This should be optional, but I was trying to install with Cuda support
export CUDA_HOME=/hpc/superpod/testing/spack/opt/spack/linux-ubuntu20.04-zen2/gcc-10.3.0/cuda-11.4.4-ctldo35wmmwws3jbgwkgjjcjawddu3qz

```

## Build UCX
```
cd ucx-1.13.0-rc1/

# overzealous options. I'm not sure what we actually need. I tried turning on 
# most of the IB / Mellanox options
./autogen.sh
./configure \
--disable-logging \
--disable-debug \
--disable-assertions \
--disable-params-check \
--with-knem \
--without-java \
--enable-devel-headers \
--enable-examples \
--with-cuda=${CUDA_HOME} \
--with-mlx5-dv \
--with-ib-hw-tm \
--with-rc \
--with-ud \
--with-dc \
--prefix=${UCX_INSTALL_PATH}

make -j
make -j install
```

## Build UCC (optional)

```
cd ../ucc-1.0.0

./autogen.sh

./configure \
--disable-debug \
--with-cuda=${CUDA_HOME} \
--with-ucx=${UCX_INSTALL_PATH} \
--prefix=${UCC_INSTALL_PATH}

make -j
make -j install
```

## Build Open MPI

```
cd ../openmpi-4.1.4

./configure \
CC=$(which gcc) \
CXX=$(which g++) \
F77=$(which gfortran) \
FC=$(which gfortran) \
--prefix=${INSTALL_LOC} \
--with-hcoll=/opt/mellanox/hcoll \
--with-ucx=${UCX_INSTALL_PATH} \
--with-ucc=${UCC_INSTALL_PATH} \
--with-platform=contrib/platform/mellanox/optimized \
--with-pmix=/opt/nvidia-cluster-tools/pmix \
--with-hwloc=/opt/nvidia-cluster-tools/hwloc \
--with-libevent=/usr \
--with-cuda=${CUDA_HOME} \
--with-pmi=/usr/local \
--with-slurm=/usr/local \
2>&1 | tee config-gcc@10.3.0-output.log

make -j 2>&1 | tee build-gcc@10.3.0-output.log
make -j install 2>&1 | tee install-gcc@10.3.0-output.log
```

## Notes

- PMIX doesn't seem to be correct. The output from `config` seems to suggest 
  that it installs it's own newer version. This would explain issues with Slurm
  integration
  ```
  cat config-gcc@10.3.0-output.log | grep pmi
  configure: pmix builddir: /hpc/superpod/testing/mpi/openmpi/build/openmpi-4.1.4/opal/mca/pmix/pmix3x/pmix
  configure: pmix srcdir: /hpc/superpod/testing/mpi/openmpi/build/openmpi-4.1.4/opal/mca/pmix/pmix3x/pmix
  checking for pmix version... 3.2.3
  ```
- Running with Slurm requires specifying `mpi=pmi2`. It should be able to use PMIx.
- Running a `hello world` program with more than 16 tasks per node crashes (this is alleviated by 
  turning off hcoll, e.g. `export OMPI_MCA_coll=^hcoll`)
- In some cases it seems necessary to specify the interfaces, e.g. `export UCX_NET_DEVICES=mlx5_0:1,mlx5_1:1,mlx5_2:1,mlx5_3:1,mlx5_6:1,mlx5_7:1,mlx5_8:1,mlx5_9:1`
- Turning off `usock` is maybe helpful (the Nvidia containers all do this). E.g. `PMIX_MCA_ptl=^usock`
- I've tried these settings. As mentioned, disabling HCOLL is the only one that seems to make much difference
  ```
  # from https://docs.nvidia.com/networking/display/HPCXv27/Known+Issues
  #export UCX_TLS=dc_x,self,sm

  # these appear to be the network cards?
  UCX_NET_DEVICES=mlx5_0:1,mlx5_1:1,mlx5_2:1,mlx5_3:1,mlx5_6:1,mlx5_7:1,mlx5_8:1,mlx5_9:1

  # these are in the NGC containers
  export OMPI_MCA_btl_openib_warn_default_gid_prefix=0
  export OMPI_MCA_btl_tcp_if_include=enp225s0f1
  export PMIX_MCA_gds=hash
  export PMIX_MCA_psec=none
  export PMIX_MCA_ptl=^usock
  #export PMIX_PTL_MODULE=tcp

  # from https://github.com/openucx/ucx/issues/6669
  export OMPI_MCA_coll=^hcoll # this definitely makes a difference.
  #export UCX_RC_MLX5_TX_NUM_GET_BYTES=256k # get warnings this is unused
  #export UCX_RC_MLX5_MAX_GET_ZCOPY=32k # get warnings this is unused

  ```
