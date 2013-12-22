class planet_dump::minute_diff {
    include osmosis

    file {'/srv/planet/replication':
        ensure => directory,
        owner => 'paladin',
        mode => 755
    }

    file {'/srv/planet/replication/minute':
        ensure => directory,
        owner => 'paladin',
        mode => 755
    }

    file { '/srv/planet/replication/minute/state.txt':
        replace => no,
        owner => 'paladin',
        mode => 644,
        source => 'puppet:///modules/planet_dump/state.txt.bootstrap'
    }

    file {'/etc/cron.d/osm-minute-diff':
        require => [Class['osmosis'], File['/srv/planet/replication/minute/state.txt'], File['/var/log/planet'],
                    User['paladin']],
        content => "* * * * * paladin nice -n 18 /usr/local/bin/osmosis --replicate-apidb validateSchemaVersion=false user=paladin database=osm --write-replication workingDirectory=/srv/planet/replication/minute/ >>/var/log/planet/minute.log 2>&1\n"
    }

}