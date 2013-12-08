import 'users.pp'

Exec { 
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
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