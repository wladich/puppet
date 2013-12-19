#!/bin/bash
set -e
WORK_DIR=/var/lib/osm_replicate
CHANGES_FILE=$WORK_DIR/changes.xml

echo Stopping updater service
stop replicated || true

echo reset updater state

echo "sequenceNumber=0
timestamp=2000-12-15T14\:45\:15Z
" > $WORK_DIR/state.txt

if [ -e "$CHANGES_FILE" ]; then rm "$CHANGES_FILE"; fi

echo deleting and recreatig empty tables
echo "<?xml version='1.0' encoding='UTF-8'?><osmChange version=\"0.6\"></osmChange>" |\
 sudo -u replicator /usr/local/bin/osm2pgsql --slim --create --style /var/lib/osm_replicate/osm2pgsql.style --cache 100 -

echo starting updater service
start replicated