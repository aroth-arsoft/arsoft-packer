#!/bin/bash
# Debian based scripting
set -e
set -x

release=$(lsb_release -cs)
DEBIAN_FRONTEND=noninteractive
sudo su -c 'echo libc6:amd64 libraries/restart-without-asking boolean true| debconf-set-selections'
sudo su -c 'echo libc6 libraries/restart-without-asking boolean true| debconf-set-selections'

case "$release" in
	precise)
	#sudo mv /etc/apt/sources.list /etc/apt/sources.list.orig
	#sudo wget -O /etc/apt/sources.list http://buaya.klas.or.id/etc/src-list-precise-canonical.txt
	;;
	*)
	echo "doing nothing"
	;;
esac
# Updating and Upgrading dependencies
sudo apt-get update 
sudo apt-get install aptitude -y
sudo apt-get upgrade -y > /dev/null
sudo apt-get dist-upgrade -y > /dev/null
# Install necessary libraries for guest additions and Vagrant NFS Share

case "$release" in
    lucid)
    sudo aptitude -y -q install dkms nfs-common linux-image-virtual linux-virtual linux-headers-virtual virtualbox-ose-guest-utils virtualbox-ose-guest-dkms lsb-release
    ;;
    *)
    sudo aptitude -y -q install dkms nfs-common linux-image-virtual linux-virtual linux-headers-virtual virtualbox-guest-utils virtualbox-guest-dkms lsb-release
    ;;
esac


# Install necessary dependencies
sudo aptitude -y -q install curl

# Setup sudo to allow no-password sudo for "admin"
#groupadd -r admin
#usermod -a -G admin vagrant
