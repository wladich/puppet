#!/bin/bash
set -e

DUMP=$1
if [ -z "$DUMP" ]; then
    echo "Usage: $0 <DUMP_FILE>"
    exit 1
fi

if [ ! -f "$DUMP" ]; then
    echo "File $DUMP not found"
    exit 1
fi

chmod -x /usr/local/bin/osmosis
/etc/init.d/uwsgi stop osm
stop gpximport
stop cgimap

#su postgres -c "psql -c \"SELECT pg_terminate_backend(pg_stat_activity.procpid)
#    FROM pg_stat_activity
#    WHERE pg_stat_activity.datname = 'osm'
#      AND procpid <> pg_backend_pid()\""
su postgres -c "psql -c \"DROP DATABASE IF EXISTS osm\""
pushd /home/osm/site
git checkout HEAD~1
popd
[ -e /srv/planet ] && rm -r /srv/planet

puppet apply /etc/puppet/manifests/site.pp  -v
sudo -u postgres pg_restore --disable-triggers -d osm "$DUMP"
chmod +x /usr/local/bin/osmosis
sudo -u paladin /usr/local/bin/planet_dump.sh
