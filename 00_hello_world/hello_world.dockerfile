FROM nvcr.io/nvidia/nvhpc:22.3-devel-cuda_multi-ubuntu20.04 as builder
WORKDIR /build
COPY hello_world.cpp ./
RUN nvc++ -Bstatic -o hello_world hello_world.cpp

FROM alpine:3.15.4
WORKDIR /opt/hello/bin
COPY --from=builder /build/hello_world ./
ENTRYPOINT ["/opt/hello/bin/hello_world"]

