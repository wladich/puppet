class uwsgi {
    package {'uwsgi': }
    package {'uwsgi-plugin-rack-ruby1.9.1': }
    service { 'uwsgi':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['uwsgi']
    }
}

class nginx {
    package {'nginx-full':}
    service { 'nginx':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['nginx-full']
    }

}

class osm_server {
    include uwsgi
    include nginx
    file {'/etc/uwsgi/apps-enabled/osm.ini':
        mode => 644,
        source => "puppet:///files/osm/uwsgi.config",
        notify => Service['uwsgi'],
        }
    file {'/etc/nginx/sites-enabled/osm':
        mode => 644,
        source => "puppet:///files/osm/nginx.config",
        notify => Service['nginx'],
        }

}
