#!/bin/sh
#patronictl -c /etc/patroni/postgres.yml list cluster-test-pgsql
./oshell "systemctl stop patroni"
./oshell "systemctl stop consul"
./oshell "rm -rf /var/consul/*"
./oshell "rm -rf /var/lib/pgsql/9.6/"
