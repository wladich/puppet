class tiles::mod_tile_config {
    class {'apache_mod_tile':
      require => Class['apache']
    }

    apache::mod { 'tile': 
        notify => Service['apache2'],
    }
      
    file {'/var/lib/tiles/tiles':
        ensure => directory,
        owner => 'tiles'
    }

    file { '/etc/rsyslog.d/renderd.conf':
        source => 'puppet:///modules/tiles/renderd.rsyslog',
        notify => Service['rsyslog']
    }

    file {'/etc/init.d/renderd':
        ensure => absent,
        notify => Service['renderd']
    }
    
    file {'/var/run/renderd':
        ensure => directory,
        owner => 'tiles'
    }

    file {'/etc/init/renderd.conf':
        source => 'puppet:///modules/tiles/renderd.init.conf',
        mode => 0644,
        notify => Service['renderd']
    }

    file {'/etc/renderd.conf':
        source => 'puppet:///modules/tiles/renderd.conf',
        mode => 0644,
        notify => Service['renderd']
    }

    service {'renderd':
      ensure => running,
      enable => true,
      require => [Class['apache_mod_tile'], File['/var/run/renderd']]
    }

    apache::vhost { 'tiles.osm':
        notify => Service['apache2'],
        vhost_name => '*',
        port => '8579',
        docroot => '/var/lib/tiles',
        log_level => info,
        access_log_file => 'tiles_access.log',
        error_log_file => 'tiles_error.log',
        custom_fragment => '
            ModTileTileDir /var/lib/tiles/tiles
            LoadTileConfigFile /etc/renderd.conf
            ModTileRequestTimeout 30
            ModTileMissingRequestTimeout 30
            ModTileRenderdSocketName /var/run/renderd/renderd.sock
        '


# Enable the rewrite engine
#  RewriteEngine on
# Rewrite tile requests to the default style
#  RewriteRule ^/(-?\d+)/(-?\d+)/(-?\d+)\.png$ /default/$1/$2/$3.png [PT,T=image/png,L]
#  RewriteRule ^/(-?\d+)/(-?\d+)/(-?\d+)\.png/status/?$  /default/$1/$2/$3.png/status [PT,T=text/plain,L]
#  RewriteRule ^/(-?\d+)/(-?\d+)/(-?\d+)\.png/dirty/?$   /default/$1/$2/$3.png/dirty  [PT,T=text/plain,L]

    }

}