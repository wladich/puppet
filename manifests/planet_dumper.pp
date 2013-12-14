class planet_dumper {
    include osmosis

    group { 'paladin' : 
        ensure => present
    }
    user { 'paladin': 
        shell => '/bin/false',
        managehome => no,
        gid => 'paladin',
        require => Group['paladin']
    }

#    postgresql::server::role { "paladin": }
#    postgresql::server::database_grant { 'planet dumps':
#      privilege => 'ALL',
#      db        => 'osm',
#      role      => 'paladin',
#    }
    postgresql::server::pg_hba_rule { 'trust access for java clients. FIXME: add password':
      type        => 'host',
      address     => '127.0.0.1/32',
      database    => 'osm',
      user        => 'osm',
      auth_method => 'trust',
      order       => '003',
    }


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
        ensure => present,
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