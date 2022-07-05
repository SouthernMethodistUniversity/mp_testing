# Notes

**All code in this repo is for testing. The code may not work and may change. Pull requests and issues welcome.**

See [Quick Start Notes](quick_start_notes.md) for a short overview of MP usage.

## Usage Example

```sh
git clone https://github.com/SouthernMethodistUniversity/mp_testing.git
cd mp_testing/demos/00_nemo
./submit_jobs.sh
```

## Applications
- LAMMPS (NGC)
- AMBER
- NAMD (NGC)
- OpenMM
- Gaussian
- VASP
- CRYSTAL
- Q-Chem
- Quantum Espresso

## Analysis Tools
- Memory profiling
- Performance profiling

## Libraries/APIs
- Raja
- Magma
- heFFTe
- Pandas
- NumPy
- TensorFlow
- PyTorch
- DALI

## Languages
- C
- C++
- Python
- Some custom layer in C++/CUDA
- Fortran
- CUDA Fortran
- Julia

## Molecular Dynamics
- OpenMM
- AMBER
- Desmond
- GROMACS
- Mentioned MIC modes?
- NGC for Keras/TF and Pytorch


## Issues

- Can't run enroot images directly via `enroot start hello_world.sqsh`. The OS
  needs squashfuse and fuse-overlayfs installed. I installed these on Easley and
  it works.
- Custom build and final images for containerized Spack environments fails due
  to apparently assuming that Spack already exists. See: `01_spack/spack_nvhpc.yaml`.
- Spack-blessed NVIDIA container fails to build due to public key error. See: `01_spack/spack_lammps.yaml`.
- `export ENROOT_MOUNT_HOME=1` to bind $HOME.
- Default flags and `target=zen2` gave LAMMPS run times of 4:44, while `target=zen2 cppflags=-O3`
- Running containers or non-hpc-x MPI produces warnings about `Unknown interface name` / 
  `An invalid value was given for btl_tcp_if_include`. It appears not to see the Mellanox / IB correctly?

## Maybe Useful
- https://www.nvidia.com/content/dam/en-zz/Solutions/Data-Center/tesla-product-literature/gpu-applications-catalog.pdf
- https://docs.nvidia.com/deeplearning/frameworks/support-matrix/index.html
- https://docs.nvidia.com/deeplearning/dali/user-guide/docs/index.html
- https://secure.cci.rpi.edu/wiki/

## Things we need to plan for
- How and when do we decide we're updating Nvidia Drivers / Cuda. I think we need to be very clear about this if we're not going to maintain the latest and greatest. (we're currently on 11.4, but 11.7 and associated drivers are available)
