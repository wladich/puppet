class osm_site {
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

    postgresql::server::pg_hba_rule { 'local access as osm user':
      type        => 'local',
      database    => 'osm',
      user        => 'osm',
      auth_method => 'ident',
      order       => '002',
    }
    
    postgresql::server::role { "osm": }
    postgresql::server::database { "osm":
        owner => "osm",
        encoding => "UTF-8",
        locale =>  "en_US.UTF-8",
        require => Postgresql::Server::Role["osm"]
    }

    group { 'osm': 
        ensure => present
    }

    file { 'osm_home': 
        ensure => 'directory',
        path => '/home/osm',
        owner => 'osm',
        group => 'osm',
        mode => 700,
        require => User['osm'] }

    user { 'osm': 
        shell => '/bin/false',
        managehome => no,
        home => '/home/osm',
        gid => 'osm',
        require => Group['osm']
    }
}
