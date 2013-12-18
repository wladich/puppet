import 'base.pp'
import 'users.pp'
import 'utilities.pp'
import 'osmsite.pp'
import 'osmserver.pp'

include user_w
class {'osm_site':
    oauth_consumer_key => 'CLeSHohiodgrZ5YKR4Uuk8hF6upW8QO3ypzyvI23'
    }
include osm_server
include cgimap
include planet_dump

class {'tiles':
    minute_diff_url => 'http://planet.osm.wladich.tk/replication/minute/'
}
