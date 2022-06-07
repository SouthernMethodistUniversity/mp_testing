
help([[Mellanox HPC-X toolkit

pcx 
v2.11
gcc
MLNX_OFED_LINUX-5
ubuntu20.04
cuda11
gdrcopy2
nccl2.11
x86_64

WARNING: This is a test install and may be removed without notice
]])

whatis("Name: HPC-X")
whatis("Version: 2.11")
whatis("Category: Testing (subject to being removed without notice)")
whatis("Keywords: mellanox, hpc-x, hpcx, mpi")
whatis("URL: https://developer.nvidia.com/networking/hpc-x")
whatis("Description: NVIDIA® HPC-X® is a comprehensive software package that includes Message Passing Interface (MPI), Symmetrical Hierarchical Memory (SHMEM) and Partitioned Global Address Space (PGAS) communications libraries, and various acceleration packages. This full-featured, tested, and packaged toolkit enables MPI and SHMEM/PGAS programming languages to achieve high performance, scalability, and efficiency and ensures that communication libraries are fully optimized by NVIDIA Quantum InfiniBand networking solutions.")
family("MPI")

local hpcx_dir="/hpc/superpod/testing/nvidia/hpcx-v2.11-gcc-MLNX_OFED_LINUX-5-ubuntu20.04-cuda11-gdrcopy2-nccl2.11-x86_64"
local hpcx_ucx_dir=pathJoin(hpcx_dir, "ucx")
local hpcx_ucc_dir=pathJoin(hpcx_dir, "ucc")
local hpcx_sharp_dir=pathJoin(hpcx_dir, "sharp")
local hpcx_nccl_rdma_sharp_plugin_dir=pathJoin(hpcx_dir, "nccl_rdma_sharp_plugin")
local hpcx_hcoll_dir=pathJoin(hpcx_dir, "hcoll")
local hpcx_mpi_dir=pathJoin(hpcx_dir, "ompi")
local hpcx_oshmem_dir=hpcx_mpi_dir
local hpcx_mpi_tests_dir=pathJoin(hpcx_mpi_dir, "tests")
local hpcx_osu_dir=pathJoin(hpcx_mpi_tests_dir, "osu-micro-benchmarks-5.8")
local hpcx_osu_cuda_dir=pathJoin(hpcx_mpi_tests_dir, "osu-micro-benchmarks-5.8-cuda")
local hpcx_ipm_dir=pathJoin(hpcx_mpi_tests_dir, "ipm-2.0.6")
local hpcx_ipm_lib=pathJoin(hpcx_ipm_dir, "lib/libipm.so")
local hpcx_clusterkit_dir=pathJoin(hpcx_dir, "clusterkit")

setenv("HPCX_DIR", hpcx_dir)
setenv("HPCX_UCX_DIR", hpcx_ucx_dir)
setenv("HPCX_UCC_DIR", hpcx_ucc_dir)
setenv("HPCX_SHARP_DIR", hpcx_sharp_dir)
setenv("HPCX_NCCL_RDMA_SHARP_PLUGIN_DIR",hpcx_nccl_rdma_sharp_plugin_dir)
setenv("HPCX_HCOLL_DIR", hpcx_hcoll_dir)
setenv("HPCX_MPI_DIR", hpcx_mpi_dir)
setenv("HPCX_OSHMEM_DIR", hpcx_oshmem_dir)
setenv("HPCX_MPI_TESTS_DIR", hpcx_mpi_dir)
setenv("HPCX_OSU_DIR", hpcx_osu_dir)
setenv("HPCX_OSU_CUDA_DIR", hpcx_osu_cuda_dir)
setenv("HPCX_IPM_DIR", hpcx_ipm_dir)
setenv("HPCX_IPM_LIB", hpcx_ipm_lib)
setenv("HPCX_CLUSTERKIT_DIR", hpcx_clusterkit_dir)
setenv("OMPI_HOME", hpcx_mpi_dir)
setenv("MPI_HOME", hpcx_mpi_dir)
setenv("OSHMEM_HOME", hpcx_mpi_dir)
setenv("SHMEM_HOME", hpcx_mpi_dir)


setenv("OPAL_PREFIX", hpcx_mpi_dir)
prepend_path("PATH", pathJoin(hpcx_mpi_dir, "bin"))
prepend_path("PATH", pathJoin(hpcx_ucx_dir, "bin"))
prepend_path("PATH", pathJoin(hpcx_ucc_dir, "bin"))
prepend_path("PATH", pathJoin(hpcx_hcoll_dir, "bin"))
prepend_path("PATH", pathJoin(hpcx_clusterkit_dir, "bin"))

prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_mpi_dir, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_hcoll_dir, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_sharp_dir, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_ucx_dir, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_ucx_dir, "lib/ucx"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_ucc_dir, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_ucc_dir, "lib/ucc"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_nccl_rdma_sharp_plugin_dir, "lib"))

prepend_path("LIBRARY_PATH", pathJoin(hpcx_mpi_dir, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_hcoll_dir, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_ucx_dir, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_ucc_dir, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_sharp_dir, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_mpi_dir, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_nccl_rdma_sharp_plugin_dir, "lib"))

prepend_path("CPATH", pathJoin(hpcx_hcoll_dir, "include"))
prepend_path("CPATH", pathJoin(hpcx_sharp_dir, "include"))
prepend_path("CPATH", pathJoin(hpcx_ucx_dir, "include"))
prepend_path("CPATH", pathJoin(hpcx_ucc_dir, "include"))
prepend_path("CPATH", pathJoin(hpcx_mpi_dir, "include"))

prepend_path("PKG_CONFIG_PATH", pathJoin(hpcx_mpi_dir, "lib/pkgconfig"))
prepend_path("PKG_CONFIG_PATH", pathJoin(hpcx_hcoll_dir, "lib/pkgconfig"))
