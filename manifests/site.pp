import 'users.pp'
import 'utilities.pp'

Exec { 
      path => '/usr/bin:/bin:/usr/sbin:/sbin',
}

class { "ssh::server":
  permit_root_login => 'yes',
  allowed_users => ["w", "root"],
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
