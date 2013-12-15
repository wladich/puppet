#!/bin/bash
set -e
LOG=/var/log/osm2pg_direct/osm2pg_direct.log
STATE_DIR=/var/lib/osm2pg_direct
TMP_FILE=/tmp/__osm_changes

exec >> $LOG 2>&1

while true; do
    /usr/local/bin/osmosis \
        --replicate-apidb validateSchemaVersion=false user=osm database=osm\
        --replication-to-change workingDirectory=$STATE_DIR\
        --simplify-change --write-xml-change $TMP_FILE

    tables=`psql  -d gis -c '\dt;'`
    if [[ "tables" == "*planet_osm_point*" ]]; then
        action="--append"
        echo "Creating tables in database gis"
    else
        action="--create"
    fi

    osm2pgsql --slim $action $TMP_FILE --style /opt/osm2pg_direct/mappodm.style --cache 100 -U paladin
    #TODO: invalidate tiles
    rm $TMP_FILE
    sleep 30
done