#!/bin/bash
set -x
set -e

#install -v -o vagrant -g vagrant -m 0700 -d /home/vagrant/.ssh
rm -rf ~vagrant/.ssh/
mkdir ~vagrant/.ssh/
chown vagrant:vagrant ~vagrant/.ssh/
chmod 700 ~vagrant/.ssh/
curl -o /home/vagrant/.ssh/authorized_keys -kL 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys

#groupadd -fr admin
#usermod -a -G admin vagrant

sudo cp /etc/sudoers /etc/sudoers.orig
sudo sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sudo sed -i -e 's/%admin ALL=(ALL) ALL/%vagrant ALL=NOPASSWD:ALL/g' /etc/sudoers
#sudo rm -f /etc/sudoers.d/README
#sudo wget -O /etc/sudoers.d/vagrant https://gist.githubusercontent.com/udienz/e7da35b3f059afe52710/raw/72b10b2456ae46f24f23bcad3b8e0499487e4f42/sudoers


#sudo /bin/su -c "echo 'vagrant ALL=NOPASSWD:ALL' > /etc/sudoers.d/vagrant"
#chmod 440 /etc/sudoers.d/vagrant
