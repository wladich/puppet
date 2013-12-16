class osmosis {
    include java

    file { '/var/cache/puppet/osmosis.tgz' :
        source => 'puppet:///modules/osmosis/osmosis-0.43.1.tgz',
        notify => Exec['unpack osmosis']
    }

    exec {'unpack osmosis':
        command => 'mkdir -p /opt/osmosis && 
                    touch /opt/osmosis/dimmy && 
                    rm -r /opt/osmosis/* && 
                    tar xaf /var/cache/puppet/osmosis.tgz -C /opt/osmosis',
        refreshonly => true,
        require => File['/var/cache/puppet/osmosis.tgz']
    }
    
    file { '/usr/local/bin/osmosis':
        ensure => 'link',
        target => '/opt/osmosis/bin/osmosis'
    }
}
