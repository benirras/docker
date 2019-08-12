# Document root

It's set in images/apache/vhost.conf 

# Communication between the PHP / Apache container

This occurs via FCGI - a socket is shared between containers - relating to the `runphp` and `runphp-worpdress` named volume.

# Wordpress vhost

# Wordpress database credentials

The scripts/createWordpressUser.sh does:
user: wordpress-user
password: eternity-radix-veldt-dropkick1
database: wordpress
host: database
