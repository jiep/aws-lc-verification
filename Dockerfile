# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0


FROM ubuntu:20.04
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get install -y wget unzip git cmake clang llvm golang python3-pip libncurses5 opam libgmp-dev
RUN pip3 install wllvm

RUN opam init --disable-sandboxing
RUN opam install -vv -y coq.8.13.2
RUN opam repo add coq-released https://coq.inria.fr/opam/released
RUN opam install -y coq-bits

ADD ./SAW/scripts /lc/scripts
RUN /lc/scripts/install.sh
ENV CRYPTOLPATH=../../../cryptol-specs

# This container expects all files in the directory to be mounted or copied. 
# The GitHub action will mount the workspace and set the working directory of the container.
# Another way to mount the files is: docker run -v `pwd`:`pwd` -w `pwd` <name>

ENTRYPOINT ["./SAW/scripts/docker_entrypoint.sh"]
