#!/bin/bash
# Debian based scripting
set -e
set -x

release=$(lsb_release -cs)
export DEBIAN_FRONTEND=noninteractive
sudo su -c 'echo libc6:amd64 libraries/restart-without-asking boolean true| debconf-set-selections'
sudo su -c 'echo libc6 libraries/restart-without-asking boolean true| debconf-set-selections'

sudo rm /etc/apt/sources.list.d/ppa-aroth.list 2>/dev/null || true
sudo rm /etc/apt/sources.list.d/puppetlabs-pc1.list 2>/dev/null || true

release=$(lsb_release -cs)

echo "# /tmp/ppa-aroth.list" >> /tmp/ppa-aroth.list
echo "deb http://ppa.launchpad.net/aroth/ppa/ubuntu $release main" >> /tmp/ppa-aroth.list
echo "deb-src http://ppa.launchpad.net/aroth/ppa/ubuntu $release main" >> /tmp/ppa-aroth.list

sudo mv /tmp/ppa-aroth.list /etc/apt/sources.list.d/ppa-aroth.list

puppetlabs_release="$release"
[ "$puppetlabs_release" = 'utopic' ] && puppetlabs_release='trusty'
[ "$puppetlabs_release" = 'vivid' ] && puppetlabs_release='trusty'
[ "$puppetlabs_release" = 'wily' ] && puppetlabs_release='trusty'

echo "# Puppetlabs PC1 $puppetlabs_release Repository" >> /tmp/puppetlabs-pc1.list
echo "deb http://apt.puppetlabs.com $puppetlabs_release PC1" >> /tmp/puppetlabs-pc1.list
echo "#deb-src http://apt.puppetlabs.com $puppetlabs_release PC1" >> /tmp/puppetlabs-pc1.list

sudo mv /tmp/puppetlabs-pc1.list /etc/apt/sources.list.d/puppetlabs-pc1.list

echo "deb http://ppa.launchpad.net/kubuntu-ppa/backports/ubuntu $release main" >> /tmp/kubuntu-backports.list
echo "deb-src http://ppa.launchpad.net/kubuntu-ppa/backports/ubuntu $release main" >> /tmp/kubuntu-backports.list

sudo mv /tmp/kubuntu-backports.list /etc/apt/sources.list.d/kubuntu-backports.list

function apt_add_http_key() {
    local keysource="$1"
    local gpgkey=`/usr/bin/wget -q -O - "$keysource"`
    local RET=1
    if [ $? -eq 0 ]; then
        gpgmsg=`echo "$gpgkey" | sudo /usr/bin/apt-key add - 2>&1`
        if [ $? -eq 0 ]; then
            RET=0
        fi
    fi
    return $RET
}


function apt_add_gpg_key() {
    local keysource="$1"
    local keyid="$2"
    local gpgmsg=`/usr/bin/gpg -q --keyserver "$keysource" --recv-keys "$keyid" 2>&1`
    local RET=1
    if [ $? -eq 0 ]; then
        gpgkey=`/usr/bin/gpg -q --export --armor "$keyid" 2>/dev/null`
        if [ $? -eq 0 ]; then
            gpgmsg=`echo "$gpgkey" | sudo /usr/bin/apt-key add - 2>&1`
            if [ $? -eq 0 ]; then
                RET=0
            fi
        fi
    fi
    return $RET
}

# aroth-ppa
apt_add_gpg_key 'hkp://keyserver.ubuntu.com' 'AFF68B78'
# puppetlabs-pc1
apt_add_http_key 'http://apt.puppetlabs.com/pubkey.gpg'
# kubuntu-backports
apt_add_gpg_key 'hkp://keyserver.ubuntu.com' '8AC93F7A'

cat << EOF > /tmp/arsoft-base.preseed
console-data console-data/keymap/policy select Select keymap from full list
console-common console-data/keymap/policy select Select keymap from full list
console-common console-data/keymap/full select us-intl.iso15
EOF
cat /tmp/arsoft-base.preseed | sudo debconf-set-selections

# Updating and Upgrading dependencies
sudo apt-get update 
sudo apt-get upgrade -y > /dev/null
sudo apt-get dist-upgrade -y > /dev/null
# Install necessary libraries for guest additions and Vagrant NFS Share

export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
sudo apt-get install -y -q dkms nfs-common linux-image-virtual linux-virtual linux-headers-virtual virtualbox-guest-utils virtualbox-guest-dkms lsb-release curl arsoft-base
