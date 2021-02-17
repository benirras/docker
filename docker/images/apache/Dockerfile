# FROM debian:buster

FROM debian@sha256:903779f30a7ee46937bfb21406f125d5fdace4178074e1cc71c49039ebf7f48f

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y apache2 libapache2-mod-fcgid

## Chose either of:
## 1a Mainapp under subdomain
COPY ./mainapp_vhost.conf /etc/apache2/sites-available/mainapp_vhost.conf
## 1b. Mainapp under subdomain (SSL)
# COPY ./mainapp_vhost_ssl.conf /etc/apache2/sites-available/mainapp_vhost.conf
##

RUN a2ensite mainapp_vhost.conf

## SSL wordpress
# RUN a2enmod ssl
# COPY ssl/wordpress.crt           /etc/apache2/wordpress.crt
# COPY ssl/wordpress_chain.crt     /etc/apache2/wordpress_chain.crt
# COPY ssl/wordpress.key           /etc/apache2/wordpress.key

## SSL mainapp
# COPY ssl/mainapp.crt           /etc/apache2/mainapp.crt
# COPY ssl/mainapp_chain.crt     /etc/apache2/mainapp_chain.crt
# COPY ssl/mainapp.key           /etc/apache2/mainapp.key

## Chose either of:
## 2ba Mainapp under subpath
COPY ./wordpress_with_mainapp_subpath.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf
## 2bb Mainapp under subpath (SSL)
# COPY ./wordpress_with_mainapp_subpath_ssl.conf /etc/apache2/sites-available/000-default.conf
# RUN a2ensite 000-default.conf
##

RUN a2enmod actions proxy proxy_ajp proxy_http proxy_fcgi rewrite
RUN mkdir /var/lib/php-fcgi

RUN chmod 644 /var/log/apache2

ENV APACHE_UID 33
ENV APACHE_GID 33

RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

# RUN a2enmod php7.2

RUN apachectl configtest

ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]
