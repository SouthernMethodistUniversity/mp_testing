FROM nvcr.io/nvidia/nvhpc:22.5-devel-cuda_multi-ubuntu20.04 as builder
WORKDIR /build
COPY mpi_get_hostnames.c ./
RUN mpicc -o mpi_get_hostnames mpi_get_hostnames.c

FROM alpine:3.15.4
WORKDIR /opt/bin
COPY --from=builder /build/mpi_get_hostnames ./
ENTRYPOINT ["/opt/bin/mpi_get_hostnames"]

