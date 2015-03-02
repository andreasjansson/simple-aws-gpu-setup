#!/bin/bash

set -eux

sudo aptitude update

sudo DEBIAN_FRONTEND=noninteractive aptitude install -y -o Dpkg::Options::="--force-confnew" -o Dpkg::Options::="--force-confold" \
    build-essential \
    openssh-server \
    emacs24-nox \
    wget \
    libglu-dev \
    linux-headers-`uname -r` \
    linux-image-`uname -r` \
    linux-image-extra-`uname -r` \
    python-pip \
    python-dev \
    gfortran \
    python-matplotlib \
    libblas-dev \
    liblapack-dev \
    uuid-dev \
    libzmq-dev \
    python-nose \
    git \

export CUDA_BUILD=/mnt/cuda
export CUDA_HOME=/opt/cuda
sudo mkdir -p $CUDA_BUILD
sudo chmod 777 $CUDA_BUILD
pushd $CUDA_BUILD
sudo wget http://developer.download.nvidia.com/compute/cuda/6_0/rel/installers/cuda_6.0.37_linux_64.run
sudo chmod +x cuda_6.0.37_linux_64.run
sudo ./cuda_6.0.37_linux_64.run \
    -silent \
    -driver \
    -toolkit \
    -toolkitpath=$CUDA_HOME/toolkit \
    -samples \
    -samplespath=$CUDA_HOME/samples \
    -verbose \
    -override \
    -kernel-source-path=/usr/src/linux-headers-`uname -r`
popd

sudo update-initramfs -u

sudo ldconfig

sudo pip install \
    pylint==0.28.0 \
    ipython[all]==2.4.0 \
    theano
