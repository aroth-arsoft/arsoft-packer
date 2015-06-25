#!/bin/bash -eux
set +x

# delete all linux headers
dpkg --list | awk '{ print $2 }' | grep linux-headers | xargs sudo apt-get -y purge

# this removes specific linux kernels, such as
# linux-image-3.11.0-15-generic but 
# * keeps the current kernel
# * does not touch the virtual packages, e.g.'linux-image-generic', etc.
#
dpkg --list | awk '{ print $2 }' | grep 'linux-image-3.*-generic' | grep -v `uname -r` | xargs sudo apt-get -y purge

# delete linux source
dpkg --list | awk '{ print $2 }' | grep linux-source | xargs sudo apt-get -y purge

# delete development packages
#dpkg --list | awk '{ print $2 }' | grep -- '-dev$' | xargs sudo apt-get -y purge

# delete compilers and other development tools
#sudo apt-get -y purge cpp gcc g++

# delete X11 libraries
#apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6

# delete obsolete networking
#sudo apt-get -y purge ppp pppconfig pppoeconf

# delete oddities
sudo apt-get -y purge popularity-contest

sudo apt-get -y autoremove
sudo apt-get -y clean
rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?
rm -f /tmp/chef*deb
