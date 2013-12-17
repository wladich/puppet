#!/bin/bash
set -x
set -e

. build_func

NAME=libapache2-mod-tile
GIT="https://github.com/wladich/mod_tile.git"
DEPS="git devscripts debhelper apache2-threaded-dev libtool autoconf automake m4 python-software-properties"
BUILD="
    add-apt-repository -y ppa:mapnik/v2.2.0
    apt-get update
    apt-get install -y libmapnik-dev
    cd debian
    debuild -i -us -uc -b
"
ARTIFACTS="../libapache2-mod-tile_*.deb ../renderd*.deb"

    
do_build amd64    
do_build i386

