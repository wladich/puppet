#!/bin/bash
set -x
set -e

. build_func

NAME=osm2pgsql
GIT="https://github.com/openstreetmap/osm2pgsql.git"
DEPS="build-essential libxml2-dev libgeos++-dev libpq-dev libbz2-dev proj libtool automake git\
      libprotobuf-c0-dev protobuf-c-compiler"
BUILD="./autogen.sh
       ./configure
       make -j $((`nproc` + 1))
"
ARTIFACTS="osm2pgsql"

    
do_build amd64    
do_build i386

