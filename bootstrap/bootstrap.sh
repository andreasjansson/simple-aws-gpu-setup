#!/bin/bash

set -e

sudo apt-get update

sudo apt-get install -y \
    build-essential \
    openssh-server \
    emacs24-nox \
    wget \
    libglu-dev \
    linux-headers-`uname -r` \
    linux-image-generic \
    python-pip \
    python-dev \
    gfortran \
    python-matplotlib \
    libblas-dev \
    liblapack-dev \
    uuid-dev \
    libzmq-dev \
    ipython-notebook \
    python-nose \
    git \

sudo pip install envtpl

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

sudo CUDA_HOME=$CUDA_HOME envtpl -o /etc/environment --keep-template files/environment.tpl
sudo CUDA_HOME=$CUDA_HOME envtpl -o /etc/ld.so.conf.d/cuda.conf --keep-template files/ld_cuda.conf.tpl
sudo cp files/blacklist-cuda.conf /etc/modprobe.d/blacklist-cuda.conf
sudo cp files/50_blacklist_nouveau.conf /etc/grub.d/50_blacklist_nouveau.conf
sudo update-initramfs -u

sudo ldconfig

sudo pip install \
    pylint==0.28.0 \
    theano

envtpl -o ~/.theanorc files/dot_theanorc.tpl
mkdir ~/.emacs.d
cp files/dot_emacs ~/.emacs.d/init.el
cp files/dot_gitconfig ~/.gitconfig
