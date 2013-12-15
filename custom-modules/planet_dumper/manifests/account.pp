class planet_dumper::account {
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
}