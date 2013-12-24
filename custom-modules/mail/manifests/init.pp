class mail ( $hostname = undef ) {
    if $hostname == undef { 
        fail("hostname not defined") 
    }
    
    package {'postfix':}

    file {'/etc/aliases':
        ensure => present
    }

    file {'/etc/postfix/main.cf':
        content => template('mail/postfix.main.cf.erb'),
        notify => Exec['update mail alias database'],
        require => Package['postfix'],
    }

    service {'postfix':
        ensure => running,
        enable => true,
        require => [Package['postfix'], File['/etc/postfix/main.cf']]
    }

    exec {'update mail alias database':
        refreshonly => true,
        command => '/usr/sbin/postalias /etc/aliases',
        notify => Service['postfix']
    }


    mail::alias {"daemon": }
    mail::alias {"bin": }
    mail::alias {"sys": }
    mail::alias {"sync": }
    mail::alias {"games": }
    mail::alias {"man": }
    mail::alias {"lp": }
    mail::alias {"mail": }
    mail::alias {"news": }
    mail::alias {"uucp": }
    mail::alias {"proxy": }
    mail::alias {"www-data": }
    mail::alias {"backup": }
    mail::alias {"list": }
    mail::alias {"irc": }
    mail::alias {"gnats": }
    mail::alias {"nobody": }
    mail::alias {"libuuid": }
    mail::alias {"sshd": }
    mail::alias {"puppet": }
    mail::alias {"syslog": }
    mail::alias {"messagebus": }
    mail::alias {"postfix": }
}