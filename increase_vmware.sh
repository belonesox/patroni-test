#!/bin/sh
#patronictl -c /etc/patroni/postgres.yml list cluster-test-pgsql
./vshell "systemctl patroni stop"
./vshell "systemctl consul stop"
./vshell "rm -rf /var/consul/*"
./vshell "rm -rf /var/lib/pgsql/9.6/"

parted -s /dev/sda mkpart primary ext2  32.2GB 129GB
parted -s /dev/sda set 3 lvm on
pvcreate /dev/sda3
vgextend centos /dev/sda3
lvextend -l 100%FREE /dev/centos/root
xfs_growfs /dev/mapper/centos-root 
