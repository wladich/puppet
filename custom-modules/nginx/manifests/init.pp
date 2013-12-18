class nginx {
    package {'nginx-full':}
    service { 'nginx':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['nginx-full']
    }
    file {'/etc/nginx/sites-enabled/default':
        ensure => absent,
        notify => Service['nginx'],
    }
}
