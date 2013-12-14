class postgres_server_osm{
    class { 'postgresql::server': 
        pg_hba_conf_defaults => false
    }
}