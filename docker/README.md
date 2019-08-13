# Communication between the PHP / Apache container

This occurs via FCGI - a socket is shared between containers - relating to the `runphp-main` and `runphp-worpdress` named volumes.

# Filesystem

The apache container has both webroots mounted:
- `/var/www/html/main`
- `/var/www/html/wordpress`

While the main / wordpress container only have their own.

# HTTP routing

## Main app
Choose between subdomain or subpath via modifying the `1. or 2.` in `docker/images/apache/Dockerfile`.
If choosing a subdomain, set the subdomain in `docker/images/apache/mainapp_vhost.conf`

If using the subpath, please note the HTTP_HOST header will be one level deeper so the following code might be useful:
```
if ( ! empty( $_SERVER['HTTP_X_FORWARDED_HOST'] ) ) {
    $_SERVER['HTTP_HOST'] = array_pop(array_reverse(explode(",", $_SERVER['HTTP_X_FORWARDED_HOST'])));
}
```

# SSL

Place certificates in `docker/images/apache/ssl`. Uncomment the appropriate lines in `docker/images/apache/Dockerfile` - `SSL wordpress` and `SSL mainapp`.

# Wordpress database credentials

The scripts/createWordpressUser.sh does:

user: wordpress-user
password: eternity-radix-veldt-dropkick1
database: wordpress
host: database

# Database import / export

To export a database:
```
docker exec -it database mysqldump -u root -pabcxyz -e wordpress > wordpress.sql
sed -i '1d' wordpress.sql # get rid error on first line
```

To import a database: 
`docker exec -i database mysql -u root -pabcxyz wordpress < wordpress.sql`
