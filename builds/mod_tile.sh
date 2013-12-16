#!/bin/bash
set -x
set -e

. build_func

NAME=libapache2-mod-tile
GIT="https://github.com/wladich/mod_tile.git"
DEPS="git devscripts debhelper apache2-threaded-dev libtool libmapnik2-dev autoconf automake m4"
BUILD="cd debian
       debuild -i -us -uc -b
"
ARTIFACTS="../libapache2-mod-tile_*.deb ../renderd*.deb"

    
do_build amd64    
do_build i386

