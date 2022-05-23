# Notes

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

## Maybe Useful
- https://www.nvidia.com/content/dam/en-zz/Solutions/Data-Center/tesla-product-literature/gpu-applications-catalog.pdf
- https://docs.nvidia.com/deeplearning/frameworks/support-matrix/index.html
- https://docs.nvidia.com/deeplearning/dali/user-guide/docs/index.html
- https://secure.cci.rpi.edu/wiki/

