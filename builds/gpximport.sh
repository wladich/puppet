#!/bin/bash
set -x
set -e

. build_func

NAME=gpximport
GIT="git://git.openstreetmap.org/gpx-import.git"
DEPS="git build-essential automake autoconf \
      zlib1g-dev libbz2-dev libarchive-dev libexpat1-dev libgd2-noxpm-dev libmemcached-dev \
      libpq-dev pkg-config"
BUILD="
       make DB=postgres -C src -j $((`nproc` + 1))
"
ARTIFACTS="src/gpx-import"

    
do_build amd64    
do_build i386

