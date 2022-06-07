help([[
NVHPC Toolkit 22.3 with Cuda version 11.0

WARNING: This is a test install and may be removed without notice
]])

whatis("Name: NVHPC")
whatis("Version: 22.3")
whatis("Category: Testing (subject to being removed without notice)")
whatis("Keywords: Nvidia, Cuda, nvcc, nvc++, nvcxx, nvfortran")
whatis("URL: https://developer.nvidia.com/nvidia-hpc-sdk-downloads")
whatis("Description: The NVIDIA HPC Software Development Kit (SDK) includes the proven compilers, libraries and software tools essential to maximizing developer productivity and the performance and portability of HPC applications..")

-- dendends_on would be better ... but it doesn't seem to work
always_load("hpcx")

local nvhome="/hpc/superpod/testing/nvidia/hpc_sdk_22.3"
local target="Linux_x86_64"
local version="22.3"

local nvcudadir = pathJoin(pathJoin(pathJoin(nvhome, target), version), "cuda")
local nvcompdir = pathJoin(pathJoin(pathJoin(nvhome, target), version), "compilers")
local nvmathdir = pathJoin(pathJoin(pathJoin(nvhome, target), version), "math_libs")
local nvcommdir = pathJoin(pathJoin(pathJoin(nvhome, target), version), "comm_libs")

setenv("NVHPC", nvhome)
setenv("NVHPC_ROOT", pathJoin(pathJoin(nvhome, target), version))
setenv("CC", pathJoin(nvcompdir, "bin/nvc"))
setenv("CXX", pathJoin(nvcompdir, "bin/nvc++"))
setenv("FC", pathJoin(nvcompdir, "bin/nvfortran"))
setenv("F90", pathJoin(nvcompdir, "bin/nvfortran"))
setenv("F77", pathJoin(nvcompdir, "bin/nvfortran"))
setenv("CPP", "cpp")

prepend_path("PATH", pathJoin(nvcudadir,"bin"))
prepend_path("PATH", pathJoin(nvcompdir,"bin"))
-- prepend_path("PATH", pathJoin(nvcommdir,"mpi/bin"))
prepend_path("PATH", pathJoin(nvcompdir,"extras/qd/bin"))

prepend_path("LD_LIBRARY_PATH", pathJoin(nvcudadir,"lib64"))
prepend_path("LD_LIBRARY_PATH", pathJoin(nvcudadir,"extras/CUPTI/lib64"))
prepend_path("LD_LIBRARY_PATH", pathJoin(nvcompdir,"extras/qd/lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(nvcompdir,"lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(nvmathdir,"lib64"))
-- prepend_path("LD_LIBRARY_PATH", pathJoin(nvcommdir,"mpi/lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(nvcommdir,"nccl/lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(nvcommdir,"nvshmem/lib"))

prepend_path("CPATH", pathJoin(nvmathdir,"include"))
-- prepend_path("CPATH", pathJoin(nvcommdir,"mpi/include"))
prepend_path("CPATH", pathJoin(nvcommdir,"nccl/include"))
prepend_path("CPATH", pathJoin(nvcommdir,"nvshmem/include"))
prepend_path("CPATH", pathJoin(nvcompdir,"extras/qd/include/qd"))

prepend_path("MANPATH", pathJoin(nvcompdir,"man"))

-- setenv("OPAL_PREFIX", pathJoin(nvcommdir,"mpi/ompi"))