#!/bin/bash

set -e

DUMP_FILE=/tmp/downloaded_planet_dump.pbf
WORK_DIR=/var/lib/osm_replicate
CHANGES_FILE=$WORK_DIR/changes.xml

dump_url=$1
state_url=$2

if [ "$dump_url" == "" -o "$state_url" == "" ]; then
    echo "Usage: replication_reset.sh http://osm/path/to/planet/dump.pbf http://planet.osm/replication/munute/XXX/XXX/state.txt"
    exit 1
fi

echo "Downloading dump"
wget $dump_url -O $DUMP_FILE
wget $state_url -O /tmp/_replication_reset_state.txt


echo "Stopping updater service"
stop replicated || true
stop renderd
if [ -e "$CHANGES_FILE" ]; then rm "$CHANGES_FILE"; fi

echo "Importing planet dump"
sudo -u replicator osm2pgsql --slim --create  \
          --style /var/lib/osm_replicate/osm2pgsql.style\
          --cache 100  --disable-parallel-indexing --unlogged \
          --cache-strategy sparse \
          $DUMP_FILE
mv /tmp/_replication_reset_state.txt $WORK_DIR/state.txt

echo "Cleaning tiles cache"
touch /var/lib/tiles/tiles/dummy
rm -rf /var/lib/tiles/tiles/*

echo "Rendering all tiles"
start renderd
/usr/local/bin/redraw_tiles.sh 0 15

echo "Starting updater service"
start replicated

echo "All ok"