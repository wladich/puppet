class direct_osm2pgsql_update {
    include osmosis
    include osm2pgsql
    include planet_dumper::account
    
    file {'/opt/osm2pg_direct':
        ensure => directory,
        mode => 755
    }
    
    postgresql::server::pg_hba_rule { 'acces for updtaer to database gis':
      type        => 'local',
      database    => 'gis',
      user        => 'paladin',
      auth_method => 'ident',
      order       => '004',
    }

    postgresql::server::database { "gis":
        owner => "paladin",
        encoding => "UTF-8",
        locale =>  "en_US.UTF-8",
        notify => Exec["setup postgis for db gis for user paladin"]
    }
    
    exec {"setup postgis for db gis for user paladin":
        user => 'postgres',
        refreshonly => true,
        command => 'psql -d gis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql &&\
                    psql -d gis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql &&\
                    psql -d gis -f /usr/share/postgresql/9.1/contrib/postgis_comments.sql &&\
                    psql -d gis -c "GRANT SELECT ON spatial_ref_sys TO PUBLIC;"
                    psql -d gis -c "GRANT ALL ON geometry_columns TO paladin;"
                    '
    }

    file {'/opt/osm2pg_direct/osm2pg_direct.sh':
        source => 'puppet:///modules/direct_osm2pgsql_update/osm2pg_direct.sh',
        mode => 755
    }

    file {'/opt/osm2pg_direct/reset_osm2pg.sh':
        source => 'puppet:///modules/direct_osm2pgsql_update/reset_osm2pg.sh',
        mode => 755
    }

    file {'/opt/osm2pg_direct/mappodm.style':
        source => 'puppet:///modules/direct_osm2pgsql_update/mappodm.style',
        mode => 755
    }

    file {'/usr/local/bin/reset_osm2pg.sh':
        ensure => link,
        target => '/opt/osm2pg_direct/reset_osm2pg.sh'
    }
    
    file {'/var/log/osm2pg_direct':
        ensure => directory,
        owner => 'paladin',
        mode => 750
    }
    
    file {'/var/lib/osm2pg_direct':
        ensure => directory,
        owner => 'paladin',
        mode => 750
    }

    file {'/etc/init/osm2pg_direct.conf':
        source => 'puppet:///modules/direct_osm2pgsql_update/init.conf',
    }

    service {'osm2pg_direct':
        enable => true,
    }
}