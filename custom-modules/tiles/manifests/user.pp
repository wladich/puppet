class tiles::user {
    user { 'tiles': 
        shell => '/bin/false',
        managehome => no,
        gid => 'nogroup',
    }

    file {'/var/lib/tiles':
        ensure => directory,
        owner => 'tiles'
    }

    file {'/var/lib/tiles/styles':
        ensure => directory,
        owner => 'tiles'
    }

    postgresql::server::pg_hba_rule { 'access to db gis for user tiles':
      type        => 'local',
      database    => 'gis',
      user        => 'tiles',
      auth_method => 'ident',
    }

    postgresql::server::role { "tiles": }
    postgresql::server::database_grant { 'read postgres for rendering':
      privilege => 'CONNECT',
      db        => 'gis',
      role      => 'tiles',
      notify    => Postgresql_psql['read permossions on db gis for user tiles']
    }

    postgresql_psql  {'read permossions on db gis for user tiles':
        refreshonly => true,
        db => 'gis',
        command => 'GRANT SELECT ON ALL TABLES IN SCHEMA public TO tiles'
    }
}
