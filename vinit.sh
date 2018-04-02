#!/bin/sh
#patronictl -c /etc/patroni/postgres.yml list cluster-test-pgsql
./vshell "systemctl patroni stop"
./vshell "systemctl consul stop"
./vshell "rm -rf /var/consul/*"
./vshell "rm -rf /var/lib/pgsql/9.6/"
