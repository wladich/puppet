class tiles::mappodm_mapnik_style {
    file {'/var/lib/tiles/styles/default':
        ensure => directory,
        source => 'puppet:///modules/tiles/mappodm_style',
        recurse => true,
        notify => Service['renderd']
    }
    
}