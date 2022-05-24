help([[Mellanox HPC-X toolkit

WARNING: This is a test install and may be removed without notice
]])

whatis("Name: HPC-X")
whatis("Version: 2.10")
whatis("Category: Testing (subject to being removed without notice)")
whatis("Keywords: mellanox, hpc-x, hpcx, mpi")
whatis("URL: https://developer.nvidia.com/networking/hpc-x")
whatis("Description: NVIDIA® HPC-X® is a comprehensive software package that includes Message Passing Interface (MPI), Symmetrical Hierarchical Memory (SHMEM) and Partitioned Global Address Space (PGAS) communications libraries, and various acceleration packages. This full-featured, tested, and packaged toolkit enables MPI and SHMEM/PGAS programming languages to achieve high performance, scalability, and efficiency and ensures that communication libraries are fully optimized by NVIDIA Quantum InfiniBand networking solutions.")

local hpcx_dir=/hpc/superpod/testing/nvidia/hpc_sdk_22.3/Linux_x86_64/22.3/comm_libs/hpcx/hpcx-2.10
local hpcx_mpi_dir=pathJoin(hpcx_dir, "ompi")


setenv("HPCX_DIR", hpcx_dir)
setenv("HPCX_HOME", hpcx_dir)

setenv("HPCX_UCX_DIR", pathJoin(hpcx_dir, "ucx"))
setenv("HPCX_SHARP_DIR", pathJoin(hpcx_dir, "sharp"))
setenv("HPCX_HCOLL_DIR", pathJoin(hpcx_dir, "hcoll"))
setenv("HPCX_NCCL_RDMA_SHARP_PLUGIN_DIR", pathJoin(hpcx_dir, "nccl_rdma_sharp_plugin"))

setenv("HPCX_CLUSTERKIT_DIR", pathJoin(hpcx_dir, "clusterkit"))
setenv("HPCX_MPI_DIR", hpcx_mpi_dir)
setenv("HPCX_OSHMEM_DIR", hpcx_mpi_dir)
setenv("HPCX_IPM_DIR", pathJoin(hpcx_mpi_dir, "tests/ipm-2.0.6"))
setenv("HPCX_IPM_LIB", pathJoin(hpcx_mpi_dir, "ipm-2.0.6/lib/libipm.so"))
setenv("HPCX_MPI_TESTS_DIR", pathJoin(hpcx_mpi_dir, "tests"))
setenv("HPCX_OSU_DIR", pathJoin(hpcx_mpi_dir, "tests/osu-micro-benchmarks-5.6.2"))
setenv("HPCX_OSU_CUDA_DIR", pathJoin(hpcx_mpi_dir, "tests/osu-micro-benchmarks-5.6.2-cuda"))

prepend_path("PATH", pathJoin(hpcx_dir, "ucx/bin"))
prepend_path("PATH", pathJoin(hpcx_dir, "coll/bin"))
prepend_path("PATH", pathJoin(hpcx_mpi_dir, "tests/imb"))
prepend_path("PATH", pathJoin(hpcx_dir, "clusterkit/bin"))

prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_dir, "ucx/lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_dir, "ucx/lib/ucx"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_dir, "hcoll/lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_dir, "sharp/lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_dir, "nccl_rdma_sharp_plugin/lib"))

prepend_path("LIBRARY_PATH", pathJoin(hpcx_dir, "ucx/lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_dir, "hcoll/lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_dir, "sharp/lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_dir, "nccl_rdma_sharp_plugin/lib"))

prepend_path("CPATH", pathJoin(hpcx_dir, "hcoll/include"))
prepend_path("CPATH", pathJoin(hpcx_dir, "sharp/include"))
prepend_path("CPATH", pathJoin(hpcx_dir, "ucx/include"))
prepend_path("CPATH", pathJoin(hpcx_mpi_dir, "include"))

prepend_path("PKG_CONFIG_PATH", pathJoin(hpcx_dir, "hcoll/lib/pkgconfig"))
prepend_path("PKG_CONFIG_PATH", pathJoin(hpcx_dir, "sharp/lib/pkgconfig"))
prepend_path("PKG_CONFIG_PATH", pathJoin(hpcx_dir, "ucx/lib/pkgconfig"))
prepend_path("PKG_CONFIG_PATH", pathJoin(hpcx_dir, "ompi/lib/pkgconfig"))

prepend_path("MANPATH", pathJoin(hpcx_mpi_dir, "share/man"))

setenv("OPAL_PREFIX", hpcx_mpi_dir)
setenv("PMIX_INSTALL_PREFIX", hpcx_mpi_dir)
setenv("OMPI_HOME", hpcx_mpi_dir)
setenv("MPI_HOME", hpcx_mpi_dir)
setenv("OSHMEM_HOME", hpcx_mpi_dir)
setenv("SHMEM_HOME", hpcx_mpi_dir)

prepend_path("PATH", pathJoin(hpcx_mpi_dir, "bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(hpcx_mpi_dir, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(hpcx_mpi_dir, "lib"))
