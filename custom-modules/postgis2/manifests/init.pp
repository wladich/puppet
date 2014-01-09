class postgis2 {
    include apt
    apt::ppa { 'ppa:ubuntugis/ppa': }
    package{ 'postgresql-9.1-postgis': 
        ensure => latest
    }
    Apt::Ppa['ppa:ubuntugis/ppa'] -> Package['postgresql-9.1-postgis']
}