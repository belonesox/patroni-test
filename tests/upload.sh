#!/bin/sh
#patronictl -c /etc/patroni/postgres.yml list cluster-test-pgsql
PGPASSWORD=password1729 psql -Usuperuser -h 192.168.5.251 -p 5000 postgres -c "CREATE DATABASE osm"  
cat /data/osm/osm_180309.sql | PGPASSWORD=password1729 psql -Usuperuser -h 192.168.5.251 -p 5000 osm
