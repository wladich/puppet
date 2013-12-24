class tiles::user_replicator {
    user { 'replicator': 
        shell => '/bin/false',
        managehome => no,
        gid => 'nogroup',
    }

    file {'/var/lib/osm_replicate':
        ensure => directory,
        owner => 'replicator'
    }

    postgresql::server::pg_hba_rule { 'access to db gis for user replicator':
      type        => 'local',
      database    => 'gis',
      user        => 'replicator',
      auth_method => 'ident',
    }

    postgresql::server::role { "replicator": }

    sudo::conf { 'replicator':
        content  => "replicator ALL=(tiles) NOPASSWD: /usr/bin/render_expired",
    }
    mail::alias {'replicator':}
}
