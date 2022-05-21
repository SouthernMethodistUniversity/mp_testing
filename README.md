# Notes

## Applications
- LAMMPS
- AMBER
- NAMD
- OpenMM
- Gaussian
- VASP
- CRYSTAL

## Issues

- Can't run enroot images directly via `enroot start hello_world.sqsh`. The OS
  needs squashfuse and fuse-overlayfs installed. I installed these on Easley and
  it works.
- Custom build and final images for containerized Spack environments fails due
  to apparently assuming that Spack already exists. See: `01_spack/spack_nvhpc.yaml`.
- Spack-blessed NVIDIA container fails to build due to public key error. See: `01_spack/spack_lammps.yaml`.

