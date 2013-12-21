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


    nginx::site {'tiles':
        source => 'puppet:///modules/tiles/nginx.config',
        }

    include wget    
    file {'/usr/local/bin/replication_reset.sh':
        source => 'puppet:///modules/tiles/replication_reset.sh',
        mode => 755,
        require => Class['wget']
    }

}