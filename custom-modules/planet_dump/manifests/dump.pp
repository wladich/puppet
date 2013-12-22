class planet_dump::dump {
    include osmosis

    file {'/srv/planet/pbf':
        ensure => directory,
        owner => 'paladin',
        mode => 755,
    }

    file {'/usr/local/bin/planet_dump.sh': 
        source => 'puppet:///modules/planet_dump/planet_dump.sh',
        mode => 755
    }
    
    file {'/etc/cron.d/osm-planet-dump':
        require => [Class['osmosis'], File['/srv/planet/replication/minute/state.txt'], File['/var/log/planet'],
                    User['paladin']],
        content => "* 12 * * 3 paladin nice -n 19 /usr/local/bin/planet_dump.sh >>/var/log/planet/dump.log 2>&1\n"
    }

}