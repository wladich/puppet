define mail::alias ( $target = "root" ) {
    file_line {"mail alias for ${name}":
        path => "/etc/aliases",
        match => "^${name}:",
        line => "${name}: ${target}",
        notify => Exec['update mail alias database'],
        require => [Package['postfix'], File['/etc/aliases']]
    }
}