class uwsgi {
    package {'uwsgi': }
    package {'uwsgi-plugin-rack-ruby1.9.1': }
}


class osm_server {
    include cgimap
    include gpximport
    include uwsgi
    file {'/etc/uwsgi/apps-enabled/osm.ini':
        mode => 644,
        source => "puppet:///files/osm/uwsgi.config",
        notify => Exec['start osm uwsgi app']
        }

    exec {'start osm uwsgi app':
        command => "/etc/init.d/uwsgi start osm",
        unless => "/etc/init.d/uwsgi osm status"
    }
    exec {'restart osm uwsgi app':
        command => "/etc/init.d/uwsgi restart osm",
        refreshonly => true    
    }
    nginx::site{'osm':
        source => "puppet:///files/osm/nginx.config",
    }
}
