class osm2pgsql{
    class osm2pgsql_deps {
        package {'libgeos-3.2.2':}
        package {'libproj0':}
        package {'libprotobuf-c0':}
    }
    include osm2pgsql
    file {'/opt/osm2pgsql':
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
    file {'/opt/osm2pgsql/osm2pgsql' :
        ensure => file,
        mode => 755,
        source => "puppet:///modules/osm2pgsql/${arch}/osm2pgsql",
        require => File['/opt/osm2pgsql'],
    }

    file {'/usr/local/bin/osm2pgsql': 
        ensure => link,
        target => '/opt/osm2pgsql/osm2pgsql'
        }
}