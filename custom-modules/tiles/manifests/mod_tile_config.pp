class tiles::mod_tile_config {
    include tiles::user

    class {'apache_mod_tile':
      require => Class['apache']
    }

    apache::mod { 'tile': 
        notify => Service['apache2'],
    }

    apache::mod {'expires':}
#    apache::mod {'remoteip':}
    apache::mod {'headers':}

    file {'/var/lib/tiles/tiles':
        ensure => directory,
        owner => 'tiles'
    }

    file {'/var/lib/mod_tile':
        ensure => link,
        target => '/var/lib/tiles/tiles',
        force => true
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
        custom_fragment => "
            BufferedLogs on
#            RemoteIPHeader X-Forwarded-For
            ModTileTileDir /var/lib/tiles/tiles
            LoadTileConfigFile /etc/renderd.conf

            # Timeout before giving up for a tile to be rendered
            ModTileRequestTimeout 30

            # Timeout before giving up for a tile to be rendered that is otherwise missing
            ModTileMissingRequestTimeout 30

            # If tile is out of date, don't re-render it if past this load threshold (users gets old tile)
            #ModTileMaxLoadOld 2

            # If tile is missing, don't render it if past this load threshold (user gets 404 error)
            #ModTileMaxLoadMissing 5

            # Socket where we connect to the rendering daemon
            ModTileRenderdSocketName /var/run/renderd/renderd.sock

            # Upper bound on the length a tile will be set cacheable, which takes
            # precedence over other settings of cacheing
            #ModTileCacheDurationMax 604800

            # Sets the time tiles can be cached for that are known to by outdated and have been
            # sent to renderd to be rerendered. This should be set to a value corresponding
            # roughly to how long it will take renderd to get through its queue. There is an additional
            # fuzz factor on top of this to not have all tiles expire at the same time
            #ModTileCacheDurationDirty 900

            # Specify the minimum time mod_tile will set the cache expiry to for fresh tiles. There
            # is an additional fuzz factor of between 0 and 3 hours on top of this.
            #ModTileCacheDurationMinimum 10800

            # Lower zoom levels are less likely to change noticeable, so these could be cached for longer
            # without users noticing much.
            # The heuristic offers three levels of zoom, Low, Medium and High, for which different minimum
            # cacheing times can be specified.

            #Specify the zoom level below  which Medium starts and the time in seconds for which they can be cached
            #ModTileCacheDurationMediumZoom 13 86400

            #Specify the zoom level below which Low starts and the time in seconds for which they can be cached
            #ModTileCacheDurationLowZoom 9 518400

        "
    }

}