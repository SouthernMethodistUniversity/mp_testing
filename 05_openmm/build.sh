#!/usr/bin/env zsh

# Assumes Spack and Docker

tag=spack:openmm

spack containerize > Dockerfile &&\
 docker build -t $tag . &&\
 docker run -v /var/run/docker.sock:/var/run/docker.sock\
 -v $PWD:/output --privileged -t --rm\
 singularityware/docker2singularity $tag

