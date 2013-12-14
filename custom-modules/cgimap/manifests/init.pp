class cgimap {
    class cgimap_deps {
        package {'libpqxx-3.1':}
        package {'libfcgi0ldbl':}
        package {'libmemcached6':}
        package {'libboost-regex1.46.1':}
        package {'libboost-program-options1.46.1':}
    }
    include cgimap_deps
    file {'/opt/cgimap':
        ensure => directory,
        mode => 755
    }
    case $architecture {
        x86_64: { $arch = 'amd64'}
        amd64:  { $arch = 'amd64'}
        i386:   { $arch = 'i386'}
        x86:    { $arch = 'i386'}
        default: { fail("Unrecognized architecture") }
    }
    file {'/opt/cgimap/map' :
        ensure => file,
        mode => 755,
        source => "puppet:///modules/cgimap/${arch}/map",
        require => File['/opt/cgimap'],
        notify => Service['cgimap']
    }

    file {'/etc/init/cgimap.conf':
        source => "puppet:///modules/cgimap/init",
        mode => 644,
        notify => Service['cgimap']
    }
    file { '/var/log/cgimap': 
        ensure => 'directory',
        owner => 'osm',
        group => 'osm',
        mode => 750,
        require => Class['osm_user']
    }

    service {'cgimap':
        ensure => running,
        enable => true,
        require => [Class['cgimap_deps'], 
                    File['/opt/cgimap/map'], 
                    File['/etc/init/cgimap.conf'], 
                    File[ '/var/log/cgimap']]
    }

}