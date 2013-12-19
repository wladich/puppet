class tiles ($minute_diff_url){
    include tiles::mappodm_mapnik_style

    class { 'apache':
      default_mods        => false,
      default_confd_files => false,
      default_vhost       => false,
      mpm_module          => worker,
    }    

    include tiles::mod_tile_config

    class {'tiles::replicate_to_postgres':
        minute_diff_url => $minute_diff_url
    }

    include nginx
    file {'/etc/nginx/sites-enabled/tiles':
        source => 'puppet:///modules/tiles/nginx.config',
        notify => Service['nginx']
    }

    file {'/usr/local/bin/replication_reset.sh':
        source => 'puppet:///modules/tiles/replication_reset.sh',
        mode => 755
    }

}