class planet_dump::minute_diff {
    include osmosis
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

#    file {'/opt/planet_dump/reset_minute_diff.sh': 
#        source => 'puppet:///modules/planet_dump/reset_minute_diff.sh'
#    }
#    file {'/usr/local/bin/reset_minute_diff.sh':
#        ensure => link,
#        target => '/opt/planet_dump/reset_minute_diff.sh'
#    }
    
    cron {'minute replication':
        require => [Class['osmosis'], File['/srv/planet/replication/minute/state.txt']],
        user => 'paladin',
        minute => '*',
        command => '/usr/local/bin/osmosis -q --replicate-apidb validateSchemaVersion=false user=paladin database=osm --write-replication workingDirectory=/srv/planet/replication/minute/'
    }

}