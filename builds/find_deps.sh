#!/bin/bash

if [ "$1" == "" ]; then
    echo "Specify executable binary to inspect"
    exit 1
fi

for x in `ldd $1  | sed -re 's/.+=> ([^ ]+) \(0x.+\)/\1/' |  sed -re "s/^\s+([^ ]+) .+/\1/" `; do apt-file search --package-only $x; done | sort | uniq | grep -ve "-dbg"