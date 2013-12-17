class apache_mod_tile {
    case $architecture {
        x86_64: { $arch = 'amd64'}
        amd64:  { $arch = 'amd64'}
        i386:   { $arch = 'i386'}
        x86:    { $arch = 'i386'}
        default: { fail("Unrecognized architecture") }
    }

    $pkg_mod_tile = "libapache2-mod-tile_0.4-12~precise2_${arch}.deb"
    $pkg_renderd = "renderd_0.4-12~precise2_${arch}.deb"

    include mapnik22

    file {'/var/cache/puppet/renderd.deb':
        source    =>  "puppet:///modules/apache_mod_tile/${pkg_renderd}",
    }
    package {'renderd':
        ensure    =>  latest,
        provider  =>  dpkg,
        source    =>  '/var/cache/puppet/renderd.deb',
        require   =>  [File['/var/cache/puppet/renderd.deb'], Class['mapnik22']]
    }

    file {'/var/cache/puppet/mod_tile.deb':
        source    =>  "puppet:///modules/apache_mod_tile/${pkg_mod_tile}",
    }
    package {'mod_tile':
        ensure    =>  latest,
        provider  =>  dpkg,
        source    =>  '/var/cache/puppet/mod_tile.deb',
        require   =>  [File['/var/cache/puppet/mod_tile.deb'], Package['renderd']]
    }

}