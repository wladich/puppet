class locale {
    package {'locales':}

    file {'/etc/locale.gen': 
        content => "en_US.UTF-8",
        require => Package['locales'],
        notify => Exec['update locale']
    }
    
    exec {'update locale':
        command => '/usr/sbin/locale-gen en_US.UTF-8',
        refreshonly => true
    }
}