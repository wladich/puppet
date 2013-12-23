class gpximport {
    case $architecture {
        x86_64: { $arch = 'amd64'}
        amd64:  { $arch = 'amd64'}
        i386:   { $arch = 'i386'}
        x86:    { $arch = 'i386'}
        default: { fail("Unrecognized architecture") }
    }

    exec {'install gpximport dependecies':
        command => 'apt-get install -y\
                    libarchive12 libasn1-8-heimdal libbz2-1.0 libc6 libcomerr2 \
                    libexpat1 libfreetype6 libgcrypt11 libgd2-noxpm libgnutls26 \
                    libgpg-error0 libgssapi3-heimdal libgssapi-krb5-2 \
                    libhcrypto4-heimdal libheimbase1-heimdal libheimntlm0-heimdal \
                    libhx509-5-heimdal libjpeg-turbo8 libk5crypto3 libkeyutils1 \
                    libkrb5-26-heimdal libkrb5-3 libkrb5support0 libldap-2.4-2 \
                    libmemcached6 libp11-kit0 libpng12-0 libpq5 libroken18-heimdal \
                    libsasl2-2 libsqlite3-0 libssl1.0.0 libtasn1-3 libwind0-heimdal zlib1g'
    }

    file {'/opt/gpximport':
        ensure => directory,
        mode => 755
    }

    file {'/opt/gpximport/gpx-import' :
        ensure => file,
        mode => 755,
        source => "puppet:///modules/gpximport/${arch}/gpx-import",
        notify => Service['gpximport']
    }
    file {'/opt/gpximport/eml-templates':
        ensure => directory,
        recurse => true,
        mode => 755,
        source => "puppet:///modules/gpximport/eml-templates",
        notify => Service['gpximport']
    }

    file {'/etc/init/gpximport.conf':
        source => "puppet:///modules/gpximport/init.gpximport.conf",
        mode => 644,
        notify => Service['gpximport']
    }
 
    file {'/etc/gpximport.conf': 
        source=> "puppet:///modules/gpximport/gpximport.conf"
    }

    file { '/var/log/gpximport': 
        ensure => 'directory',
        owner => 'osm',
        mode => 750,
        require => User['osm']
    }

    service {'gpximport':
        ensure => running,
        enable => true,
        require => [User['osm'],
                    File['/opt/gpximport/gpx-import'], 
                    File['/etc/init/gpximport.conf'], 
                    File[ '/var/log/gpximport'],
                    Exec['install gpximport dependecies'],
                    File['/etc/gpximport.conf'],
                    File['/opt/gpximport/eml-templates']
                    ]
    }

}

