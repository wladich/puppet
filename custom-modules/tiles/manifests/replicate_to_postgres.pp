class tiles::replicate_to_postgres ($minute_diff_url) {
    include osmosis    
    include osm2pgsql
    include tiles::user_replicator

    postgresql::server::database { "gis":
        owner => "replicator",
        encoding => "UTF-8",
        locale =>  "en_US.UTF-8",
        notify => Exec["setup postgis for db gis for user replicator"],
        require => Class['tiles::user_replicator'],
    }
    
    package {"postgresql-9.1-postgis":}

    exec {"setup postgis for db gis for user replicator":
        user => 'postgres',
        refreshonly => true,
        require => Package["postgresql-9.1-postgis"],
        command => 'psql -d gis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql &&\
                    psql -d gis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql &&\
                    psql -d gis -f /usr/share/postgresql/9.1/contrib/postgis_comments.sql &&\
                    psql -d gis -c "GRANT SELECT ON spatial_ref_sys TO PUBLIC;"
                    psql -d gis -c "GRANT ALL ON geometry_columns TO replicator;"
                    '
    }


    file {'/var/lib/osm_replicate/configuration.txt':
        content => "baseUrl=${minute_diff_url}\nmaxInterval = 3600",
        notify => Service['replicated']
    }

    file {'/usr/local/bin/replicated':
        source => 'puppet:///modules/tiles/replicated',
        notify => Service['replicated'],
        mode => 755
    }

    file {'/etc/init/replicated.conf':
        source => 'puppet:///modules/tiles/init.replicated.conf',
        notify => Service['replicated']
    }

    file {'/var/log/replicated':
        ensure => directory,
        owner => 'replicator'
    }

    file {'/var/lib/osm_replicate/osm2pgsql.style':
        source => 'puppet:///modules/tiles/osm2pgsql.style',
        notify => Service ['replicated']
    }

    service {'replicated':
        enable => true,
        require => [
                    Exec["setup postgis for db gis for user replicator"],
                    File['/var/log/replicated']]
    }
}

