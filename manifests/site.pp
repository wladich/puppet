import 'base.pp'
import 'users.pp'
import 'utilities.pp'
import 'osmsite.pp'
import 'osmserver.pp'

include swapfile
include user_w


class {'osm_site':
    oauth_consumer_key => 'CLeSHohiodgrZ5YKR4Uuk8hF6upW8QO3ypzyvI23'
    }

include osm_server
include planet_dump


class {'tiles':
    minute_diff_url => 'http://planet.osm.wladich.tk/replication/minute/'
}

firewall { '200 allow http access':
  port   => 80,
  proto  => tcp,
  action => accept,
}

class {'mail':
    hostname => 'osm.wladich.tk'
}

mail::alias {'root':
    target => 'wladimirych@gmail.com'
}
