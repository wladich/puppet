class planet_dump {
    include planet_dump::account

    file {'/srv/planet/':
        ensure => directory,
        require => User['paladin'],
        owner => 'paladin',
        mode => 755
    }

    file {'/srv/planet/replication':
        ensure => directory,
        owner => 'paladin',
        mode => 755
    }

    file {'/opt/planet_dump':
        ensure => directory,
        mode => 755    
    }

    include planet_dump::minute_diff
    file {'/etc/nginx/sites-enabled/planet':
       mode => 644,
       source => "puppet:///modules/planet_dump/nginx.config",
       notify => Service['nginx'],
       }

}