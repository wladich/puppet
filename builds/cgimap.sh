#!/bin/bash
set -x
set -e

. build_func

NAME=cgimap
GIT="git://github.com/zerebubuth/openstreetmap-cgimap.git"
DEPS="libxml2-dev libpqxx3-dev libfcgi-dev \
      libboost-dev libboost-regex-dev libboost-program-options-dev libboost-date-time-dev libmemcached-dev \
      git build-essential automake autoconf"
BUILD="./autogen.sh
       ./configure --with-fcgi=/usr
       make -j $((`nproc` + 1))
"
ARTIFACTS="map"

    
do_build amd64    
do_build i386

