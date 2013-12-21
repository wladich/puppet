class planet_dump::account {
    user { 'paladin': 
        shell => '/bin/false',
        managehome => no,
        gid => 'nogroup',
    }

    postgresql::server::role { "paladin": }
    postgresql::server::database_grant { 'planet dumps':
      privilege => 'CONNECT',
      db        => 'osm',
      role      => 'paladin',
      notify    => Postgresql_psql['read permissions on db osm for user paladin']
    }
    postgresql_psql  {'read permissions on db osm for user paladin':
        refreshonly => true,
        db => 'osm',
        command => 'GRANT SELECT ON ALL TABLES IN SCHEMA public TO paladin;
                    ALTER DEFAULT PRIVILEGES FOR ROLE paladin GRANT SELECT ON TABLES TO paladin;'
    }
    
    postgresql::server::pg_hba_rule { 'trust access for java clients. FIXME: add password':
      type        => 'host',
      address     => '127.0.0.1/32',
      database    => 'osm',
      user        => 'paladin',
      auth_method => 'trust',
      order       => '003',
    }
}





