# FROM debian:buster

FROM debian@sha256:903779f30a7ee46937bfb21406f125d5fdace4178074e1cc71c49039ebf7f48f

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y apache2 libapache2-mod-fcgid

COPY ./mainapp_vhost.conf /etc/apache2/sites-available/mainapp_vhost.conf
RUN a2ensite mainapp_vhost.conf

## Chose either of:
## 1. Mainapp under subdomain
COPY ./wordpress_vhost.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf
##
## 2. Mainapp under subpath
#COPY ./wordpress_with_mainapp_subpath.conf /etc/apache2/sites-available/000-default.conf
#RUN a2ensite 000-default.conf
# RUN a2ensite vhost.conf
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
