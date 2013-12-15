class postgres_server_osm{
    class { 'postgresql::server':
        pg_hba_conf_defaults => false
    }

    postgresql::server::pg_hba_rule { 'local access as postgres user':
      type        => 'local',
      database    => 'all',
      user        => 'postgres',
      auth_method => 'ident',
      order       => '001',
    }
}