#!/bin/bash
set -e 

MIN_ZOOM=$1
MAX_ZOOM=$2

if [ -z "$MAX_ZOOM" ]; then
    echo "Usage $0 MIN_ZOOM MAX_ZOOM"
    exit 1
fi

for ZOOM in `seq $MIN_ZOOM $MAX_ZOOM`; do
    sql="select 
    	floor((st_xmin(bbox2) / 40075016.68 + 0.5) * pow(2, ${ZOOM})) as xmin,
    	LEAST(floor((st_xmax(bbox2) / 40075016.68 + 0.5) * pow(2, ${ZOOM}))+8, floor(pow(2, ${ZOOM})-1)) as xmax,
    	floor((1 - (st_ymax(bbox2) / 40075016.68 + 0.5)) * pow(2, ${ZOOM})) as ymin, 
        LEAST(floor((1 - (st_ymin(bbox2) / 40075016.68 + 0.5)) * pow(2, ${ZOOM}))+8, floor(pow(2, ${ZOOM})-1)) as ymax
    from
    	(select st_extent(bbox) as bbox2 from
    		(SELECT st_extent(way) as bbox from planet_osm_polygon 
    		union all SELECT st_extent(way) as bbox from planet_osm_line
    		union all SELECT st_extent(way) as bbox from planet_osm_point
    		) as t) 
    	as t2
    "
    tile_extents=`sudo -u tiles psql -A -t gis -c "$sql"`
    render_args=`echo "$tile_extents" | sed -re 's/^([0-9]+)\|([0-9]+)\|([0-9]+)\|([0-9]+)$/-x \1 -X \2 -y \3 -Y \4/'`
    render_list -a -f -z $ZOOM -Z $ZOOM $render_args
done