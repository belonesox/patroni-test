#!/bin/sh
#patronictl -c /etc/patroni/postgres.yml list cluster-test-pgsql
#patronictl -c /etc/patroni/postgres.yml edit-config -s 'ttl=60' -s 'retry_timeout=45' -s 'wal_keep_segments=1000'  cluster-test-pgsql
PGPASSWORD=password1729 psql -Usuperuser -h 10.200.5.101 -p 3306 postgres -c "CREATE DATABASE osm"  
# PGPASSWORD=password1729 psql -Usuperuser -h 10.200.5.101 -p 3306 postgres -c "CREATE USER osm WITH PASSWORD 'osm' WITH SUPERUSER"  
PGPASSWORD=password1729 psql -Usuperuser -h 10.200.5.101 -p 3306 postgres -c "CREATE ROLE osm SUPERUSER;"  
cat /data/osm/osm_180309.sql | PGPASSWORD=password1729 psql -Usuperuser -h 10.200.5.101 -p 3306 osm
