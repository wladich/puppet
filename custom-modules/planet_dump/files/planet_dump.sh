#!/bin/bash
set -e

DUMPS_DIR=/srv/planet/pbf
TEMP_FILE=/tmp/planet_dump_full.tmp

date_str=`date -u +%y%m%d`
destfile=${DUMPS_DIR}/planet-${date_str}.osm.pbf

/usr/local/bin/osmosis --read-apidb validateSchemaVersion=no --write-pbf file=$TEMP_FILE
mv $TEMP_FILE $destfile
cd $DUMPS_DIR
md5sum `basename $destfile` > ${destfile}.md5
echo "Planet dump succefuly created ($destfile)"