class planet_dumper {
    include osmosis
    include planet_dumper::account

    file {'/srv/planet/':
        ensure => directory,
        require => User['paladin'],
        owner => 'paladin',
        group => 'paladin',
        mode => 755
    }

    file {'/srv/planet/replication':
        ensure => directory,
        require => File['/srv/planet/'],
        owner => 'paladin',
        group => 'paladin',
        mode => 755
    }

    file {'/srv/planet/replication/minute':
        ensure => directory,
        require => File['/srv/planet/replication'],
        owner => 'paladin',
        group => 'paladin',
        mode => 755
    }

    file { '/srv/planet/replication/minute/state.txt':
        replace => no,
        require => File['/srv/planet/replication/minute'],
        owner => 'paladin',
        group => 'paladin',
        mode => 644,
        content => 'txnMaxQueried=0
sequenceNumber=0
timestamp=2013-12-14T20\:37\:53Z
txnReadyList=
txnMax=0
txnActiveList=
'
    }

    cron {'minute replication':
        require => File['/srv/planet/replication/minute/state.txt'],
        user => 'paladin',
        minute => '*',
        command => '/usr/local/bin/osmosis -q --replicate-apidb validateSchemaVersion=false user=osm database=osm --write-replication workingDirectory=/srv/planet/replication/minute'
    }
}