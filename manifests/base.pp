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

class{'locale':}

package {'rsyslog':}
service {'rsyslog':
    ensure => running,
    enable => true
}


resources { "firewall":
  purge => true
}
Firewall {
  before  => Class['my_fw_post'],
  require => Class['my_fw_pre'],
}
class { ['my_fw_pre', 'my_fw_post']: }
class { 'firewall': }
class my_fw_pre {
  Firewall {
    require => undef,
  }

  # Default firewall rules
  firewall { '000 accept all icmp':
    proto   => 'icmp',
    action  => 'accept',
  }->
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 accept related established rules':
    proto   => 'all',
    state   => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  }
}

class my_fw_post {
  firewall { '999 drop all':
    proto   => 'all',
    action  => 'drop',
    before  => undef,
  }
}
firewall { '998 allow ssh access':
  port   => 22,
  proto  => tcp,
  action => accept,
}
