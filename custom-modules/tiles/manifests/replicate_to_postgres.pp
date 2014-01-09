class tiles::replicate_to_postgres ($minute_diff_url) {
    include osmosis    
    include osm2pgsql
    include tiles::user_replicator

    postgresql::server::database { "gis":
        owner => "replicator",
        encoding => "UTF-8",
        locale =>  "en_US.UTF-8",
        notify => Postgis2::Extension['gis'],
        require => Class['tiles::user_replicator'],
    }

    postgis2::extension{'gis':
        owner => "replicator"
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
                    Postgis2::Extension['gis'],
                    File['/var/log/replicated']]
    }
}

