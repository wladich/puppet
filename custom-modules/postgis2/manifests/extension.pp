define postgis2::extension (
    $owner = "postgres"
) {
  
  include postgis2
  exec {"setup postgis for db ${db_name} for user ${owner}":
        user => "postgres",
        refreshonly => true,
        require => Package["postgresql-9.1-postgis"],
        command => "psql -d ${name} -f /usr/share/postgresql/9.1/contrib/postgis-2.0/postgis.sql &&\
                    psql -d ${name} -f /usr/share/postgresql/9.1/contrib/postgis-2.0/spatial_ref_sys.sql &&\
                    psql -d ${name} -f /usr/share/postgresql/9.1/contrib/postgis-2.0/postgis_comments.sql &&\
                    psql -d ${name} -c 'GRANT SELECT ON spatial_ref_sys TO PUBLIC;' &&\
                    psql -d ${name} -c 'GRANT ALL ON geometry_columns TO ${owner};'
                    "
    }

}