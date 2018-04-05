#!/bin/sh
#patronictl -c /etc/patroni/postgres.yml list cluster-test-pgsql
# ./vshell "parted -s /dev/sda mkpart primary ext2  32.2GB 129GB"
./vshell "parted -s /dev/sda mkpart primary ext2  32.2GB 100%"
./vshell "parted -s /dev/sda set 3 lvm on"
./vshell "pvcreate /dev/sda3"
./vshell "vgextend centos /dev/sda3"
./vshell "lvextend -l 100%FREE /dev/centos/root"
./vshell "xfs_growfs /dev/mapper/centos-root"
