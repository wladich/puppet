define nginx::site(
  $ensure   = 'file',
  $content  = undef,
  $source   = undef
) {
  include nginx
  if $content and $source {
    fail('You may not supply both content and source parameters to nginx::site')
  } elsif $content == undef and $source == undef {
    fail('You must supply either the content or source parameter to nginx::site')
  }
 
  file { "/etc/nginx/sites-enabled/${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => $content,
    source  => $source,
    require => Package['nginx-full'],
    notify  => Service['nginx'],
  }
}