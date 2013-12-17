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

file { '/var/cache/puppet' :
    ensure => directory,
    recurse => true
}

include locales
