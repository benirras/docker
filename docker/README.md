# Communication between the PHP / Apache container

This occurs via FCGI - a socket is shared between containers - relating to the `runphp-main` and `runphp-worpdress` named volumes.

# Filesystem

The apache container has both webroots mounted:
- `/var/www/html/main`
- `/var/www/html/wordpress`

While the main / wordpress container only have their own.

# HTTP routing

## HTTP -> HTTPS

TBC

## Main app
Choose between subdomain or subpath via commenting/uncomment the appropriate lines (further instructions below) in `docker/images/apache/Dockerfile`.

### Subpath /mainapp/

Follow the instructions for *Subdomain* below (but do the opposite).

### Subdomain 
Set the subdomain in `docker/images/apache/mainapp_vhost.conf`

In addition to remove the /mainapp/ proxying you should switch the vhost config referenced in the `docker/images/apache/Dockerfile` so comment this line (2ba):
```
## 2ba Mainapp under subpath
COPY ./wordpress_with_mainapp_subpath.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf
```

And uncomment (2aa)
```
## 2aa Mainapp under subdomain
COPY ./wordpress_vhost.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf
```

If using the subpath, please note the HTTP_HOST header will be one level deeper so the following code might be useful:
```
if ( ! empty( $_SERVER['HTTP_X_FORWARDED_HOST'] ) ) {
    $_SERVER['HTTP_HOST'] = array_pop(array_reverse(explode(",", $_SERVER['HTTP_X_FORWARDED_HOST'])));
}
```

# SSL

Place certificates in `docker/images/apache/ssl`. Uncomment the appropriate lines in `docker/images/apache/Dockerfile` - `SSL wordpress` and `SSL mainapp`.

# Wordpress database credentials

Within wp-config.php the following needs to be set:

```
define( 'DB_HOST', 'database' );
define( 'DB_NAME', getenv('WORDPRESS_MYSQL_DATABASE'));
define( 'DB_USER', getenv('WORDPRESS_MYSQL_USER'));
define( 'DB_PASSWORD', getenv('WORDPRESS_MYSQL_PASSWORD'));
```

The helper script `scripts/createWordpressUser.sh` can create an apporpriate database user + database with the following:

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

# ENVs / Secrets

For secrets, set them in .env (preferably don't commit this to VC - there is a gitignore entry for this), they also have to be specified in the docker-compose.yaml for each container.
Non sensitive envs can be set in docker-compose.yaml directly.

# PHPmyadmin

In terms of access, this will be given an IP in an internal subnet on the docker host.

This can be viewed with:

`sudo docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(sudo docker ps -q)`

Essentially something along the lines of:
`docker_phpmyadmin_1_438bb54c3bd1 - 172.22.0.3`

Alternatively a port on the docker host can be assigned to route to phpmyadmin.
