#!/bin/sh
#patronictl -c /etc/patroni/postgres.yml list cluster-test-pgsql
PGPASSWORD=password1729 psql -Usuperuser -h 10.200.5.101 -p 3306 postgres -c "CREATE DATABASE osm"  
cat /data/osm/osm_180309.sql | PGPASSWORD=password1729 psql -Usuperuser -h 10.200.5.101 -p 3306 osm
