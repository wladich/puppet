#!/bin/bash
set -e
STATE_DIR=/var/lib/osm2pg_direct

echo Stopping updater service
stop osm2pg_direct || true

echo reset updater state

echo "txnMaxQueried=0
sequenceNumber=1
timestamp=2013-12-15T02\:12\:24Z
txnReadyList=
txnMax=0
txnActiveList=" > $STATE_DIR/state.txt

echo deleting and recreatig empty tables
echo "<?xml version='1.0' encoding='UTF-8'?><osmChange version=\"0.6\"></osmChange>" |\
 sudo -u paladin /usr/local/bin/osm2pgsql --slim --create --style /opt/osm2pg_direct/mappodm.style --cache 100 -

echo starting updater service
start osm2pg_direct