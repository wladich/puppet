class planet_dump {
    include planet_dump::account

    file {'/srv/planet/':
        ensure => directory,
        require => User['paladin'],
        owner => 'paladin',
        mode => 755
    }

    file {'/var/log/planet':
        ensure => directory,
        owner => 'paladin',
        mode => 755
    }

    include planet_dump::minute_diff
    include planet_dump::dump

    include nginx
    file {'/etc/nginx/sites-enabled/planet':
       mode => 644,
       source => "puppet:///modules/planet_dump/nginx.config",
       notify => Service['nginx'],
       }
}