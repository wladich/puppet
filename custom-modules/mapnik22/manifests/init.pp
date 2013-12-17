class mapnik22 {
    include apt
    apt::ppa { 'ppa:mapnik/v2.2.0': }
    package{ 'libmapnik': 
        ensure => latest
    }
    Apt::Ppa['ppa:mapnik/v2.2.0'] -> Package['libmapnik']
}