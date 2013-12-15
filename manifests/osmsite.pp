class pkg_build-essential {package {'build-essential':}}
class pkg_ruby191 {package { 'ruby1.9.1': }}
class gem_bundle { package { 'bundle': ensure => present, provider => gem}}


class osm_pgfuncs_build_deps {
    include pkg_build-essential
    package {'postgresql-server-dev-all':}
}

class osm_gems_build_deps {
    include pkg_build-essential
    include pkg_ruby191
    include gem_bundle
    package {'ruby1.9.1-dev':}
    package {'zlib1g-dev':}
    package {'libxml2-dev':}
    package {'libpq-dev':}
}

class osm_site_deps {
    include pkg_ruby191
    include gem_bundle
}

class osm_site_config ($oauth_consumer_key = "") {
    file {'/home/osm/site/config/application.yml':
        content => template("application.yml.erb"),
        notify => Service['uwsgi']
    }
    file {'/home/osm/site/config/database.yml':
        source => "puppet:///files/osm/database.yml",
        notify => Service['uwsgi']
    }
}


class osm_user {
    group { 'osm': 
        ensure => present
    }

    file { 'osm_home': 
        ensure => 'directory',
        path => '/home/osm',
        owner => 'osm',
        group => 'www-data',
        mode => 750,
        require => User['osm'] }

    user { 'osm': 
        shell => '/bin/false',
        managehome => no,
        home => '/home/osm',
        gid => 'osm',
        require => Group['osm']
    }
}


class osm_pg_db {
    include postgres_server_osm

    postgresql::server::pg_hba_rule { 'local access as osm user':
      type        => 'local',
      database    => 'osm',
      user        => 'osm',
      auth_method => 'ident',
      order       => '002',
    }

    postgresql::server::role { "osm": }
    postgresql::server::database { "osm":
        owner => "osm",
        encoding => "UTF-8",
        locale =>  "en_US.UTF-8",
        require => Postgresql::Server::Role["osm"],
    }
    exec {'btree extension for osm database':
        user => 'postgres',
        refreshonly => true,
        subscribe => Postgresql::Server::Database["osm"],
        command => 'psql -d osm -c "CREATE EXTENSION btree_gist"'
    }
}

class update_pg_functions {
    include osm_pgfuncs_build_deps
    exec { 'build lib': 
        cwd => '/home/osm/site/db/functions',
        command => "make libpgosm.so && mv libpgosm.so /opt && chmod 644 /opt/libpgosm.so",
        require => Class['osm_pgfuncs_build_deps'],
        refreshonly => true,
    }

    exec { 'create pg functions':
        user => 'postgres',
        require => Exec['build lib'],
        refreshonly => true,
        command => "psql -d osm -c \"
            CREATE OR REPLACE FUNCTION maptile_for_point(int8, int8, int4) RETURNS int4 AS '/opt/libpgosm', 'maptile_for_point' LANGUAGE C STRICT;
            CREATE OR REPLACE FUNCTION tile_for_point(int4, int4) RETURNS int8 AS '/opt/libpgosm', 'tile_for_point' LANGUAGE C STRICT;
            CREATE OR REPLACE FUNCTION xid_to_int4(xid) RETURNS int4 AS '/opt/libpgosm', 'xid_to_int4' LANGUAGE C STRICT;\""
    }
}

class update_gems {
    include osm_gems_build_deps
    exec { 'install gems': 
        require => Class['osm_gems_build_deps'],
        cwd => "/home/osm/site",
        timeout => 1000,
        refreshonly => true,
        command => "/usr/local/bin/bundle install --deployment"
    }
}

class update_db_schema {
    exec { 'update_db_schema': 
        user => 'osm',
        cwd => "/home/osm/site",
        environment => ["RAILS_ENV=production",  "DB_STRUCTURE=/dev/null"],
        refreshonly => true,
        command => "/usr/local/bin/bundle exec rake db:migrate"
    }
}

class update_osm_assets {
    exec {'cleanup compiled assets':
        command => 'rm -r /home/osm/public/assets; fi',
        onlyif => '[ -e /home/osm/public/assets ]',
        refreshonly => true,
    }

    exec {'update_osm_assets':
        environment => "RAILS_ENV=production",
        cwd => "/home/osm/site",
        refreshonly => true,
        command => "/usr/local/bin/bundle exec rake assets:precompile",
        require => Exec['cleanup compiled assets']
    }    
}

class osm_site ($oauth_consumer_key = "") {
    include osm_site_deps
    include osm_user
    include osm_pg_db
    
    vcsrepo { 'osm': 
        path => '/home/osm/site',
        ensure => latest,
        provider => git,
        source => 'https://github.com/wladich/openstreetmap-website.git',
        revision => 'master',
        require => Class['osm_user'],
        notify => [Class['update_pg_functions'], Class['update_gems'], Class['update_db_schema'], 
                   Class['update_osm_assets'], Service['uwsgi']]
    }
    
    class{ 'update_pg_functions':
        require => [Vcsrepo['osm'], Class['osm_pg_db']]
    } 

    class{ 'update_gems':
        require => [Vcsrepo['osm']]
    } 

    class {'osm_site_config':
        oauth_consumer_key => $oauth_consumer_key,
        require => Vcsrepo['osm']
    }

    class{ 'update_db_schema':
        require => [Vcsrepo['osm'], Class['osm_site_deps'], Class['osm_site_config'], 
                    Class['osm_pg_db'], Class['update_gems']]
    } 
    class {'update_osm_assets':
        require => [Vcsrepo['osm'], Class['osm_site_deps'], Class['osm_site_config'], Class['update_gems']]
    }

    file { '/var/log/osm': 
        ensure => 'directory',
        owner => 'osm',
        group => 'osm',
        mode => 750,
        require => Class['osm_user'],
        before => Vcsrepo['osm']
    }
    file { '/var/lib/osm': 
        ensure => 'directory',
        owner => 'osm',
        group => 'osm',
        mode => 750,
        require => Class['osm_user'],
        before => Vcsrepo['osm']
    }

   
}
