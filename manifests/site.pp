import 'users.pp'
import 'utilities.pp'

Exec { 
      path => '/usr/bin:/bin:/usr/sbin:/sbin',
}

class { "ssh::server":
  permit_root_login => 'yes',
  allowed_users => ["w", "root"],
  password_authentication => yes
}

class { 'sudo': }

class { 'timezone':
    timezone => 'Europe/Moscow',
    autoupgrade => true
}

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

