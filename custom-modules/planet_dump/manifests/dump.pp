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
    
    cron {'weekly planet dump':
        require => [Class['osmosis'], File['/var/log/planet'], File['/srv/planet/pbf'], File['/usr/local/bin/planet_dump.sh'],
                    User['paladin']],
        user => 'paladin',
        weekday => 3,
        hour => 12,
        command => 'nice -n 19 /usr/local/bin/planet_dump.sh >>/var/log/planet/dump.log 2>&1'
    }
}