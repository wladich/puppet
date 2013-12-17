class tiles {
    include tiles::user
    include tiles::mappodm_mapnik_style

    class { 'apache':
      default_mods        => false,
      default_confd_files => false,
      default_vhost       => false,
      mpm_module          => worker,
    }    

    include tiles::mod_tile_config

}