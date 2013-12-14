#!/bin/bash
# Not used for now, may be will be used to build debs
set -e
set -x
if [ -e chroot ] ; then
    echo chroot dir exists
    exit 1
fi

function do_build {
    arch=$1
    mkdir chroot
    sudo mount -t tmpfs tmpfs chroot -o size=2G
    sudo debootstrap --arch $arch --variant minbase precise chroot http://mirror.yandex.ru/ubuntu/    
    sudo chroot chroot bash -c '
        set -x
        set -e
        echo deb http://mirror.yandex.ru/ubuntu precise main universe > /etc/apt/sources.list
        apt-get update 
        apt-get install -y git ruby1.9.1 libruby1.9.1 ruby1.9.1-dev ri1.9.1 libmagickwand-dev\
                        libxml2-dev libxslt1-dev nodejs\
                        build-essential libpq-dev postgresql-server-dev-all libsasl2-dev
        gem1.9.1 install bundle
        git clone --depth=1 https://github.com/openstreetmap/openstreetmap-website.git /osm
        cd /osm
        git log -n 1 --pretty=format:"%h %aD" > /osm-git-revision
        bundle pack
        cd /osm/db/functions
        make libpgosm.so
    '
    [ -e "../files/gems/$arch" ] && rm -r ../files/gems/$arch/
    mkdir -p ../files/gems/$arch
    cp chroot/osm/vendor/cache/*.gem ../files/gems/$arch/
    cp chroot/osm-git-revision ../files/gems/$arch/ 
    [ -e "../files/pg_func/$arch" ] && rm -r ../files/pg_func/$arch
    mkdir -p ../files/pg_func/$arch
    cp chroot/osm/db/functions/libpgosm.so ../files/pg_func/$arch/
    cp chroot/osm-git-revision ../files/pg_func/$arch/
    sudo umount chroot
    rm -r chroot
}
    
do_build amd64    
do_build i386

