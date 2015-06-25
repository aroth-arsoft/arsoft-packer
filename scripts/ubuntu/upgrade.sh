#!/bin/bash

set -x
release=$(lsb_release -cs)
DEBIAN_FRONTEND=noninteractive
sudo su -c 'echo libc6:amd64 libraries/restart-without-asking boolean true| debconf-set-selections'
sudo su -c 'echo libc6 libraries/restart-without-asking boolean true| debconf-set-selections'
sudo apt-get -y clean
sudo apt-get update -y -qq > /dev/null
sudo apt-get upgrade -y -qq > /dev/null
sudo apt-get dist-upgrade -y -qq > /dev/null


sudo apt-get install linux-headers-generic -y

case "$release" in
    lucid)
    sudo dpkg-reconfigure -f noninteractive virtualbox-ose-guest-dkms
    ;;
    *)
    sudo dpkg-reconfigure -f noninteractive virtualbox-guest-dkms
    ;;
esac
