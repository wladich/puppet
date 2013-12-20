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


class osm_server {
    include cgimap
    include uwsgi
    file {'/etc/uwsgi/apps-enabled/osm.ini':
        mode => 644,
        source => "puppet:///files/osm/uwsgi.config",
        notify => Service['uwsgi'],
        }

    nginx::site{'osm':
        source => "puppet:///files/osm/nginx.config",
    }
}
