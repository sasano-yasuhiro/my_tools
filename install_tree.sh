#!/bin/bash
# reffer: http://mama.indstate.edu/users/ice/tree/
sudo yum -y install gcc
wget ftp://mama.indstate.edu/linux/tree/tree-1.8.0.tgz
tar zxvf tree-1.8.0.tgz
cd tree-1.8.0/
make
sudo make install
tree --version
cd ..
