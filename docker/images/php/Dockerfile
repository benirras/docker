# FROM debian:buster
FROM debian@sha256:903779f30a7ee46937bfb21406f125d5fdace4178074e1cc71c49039ebf7f48f

RUN apt update

RUN apt install -y apt-transport-https lsb-release ca-certificates wget
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

RUN apt update
RUN apt install -y php7.2-fpm
# RUN apt install php7.2 php7.2-cli php7.2-common php7.2-json php7.2-opcache php7.2-mysql php7.2-zip php7.2-fpm php7.2-mbstring
RUN apt install php7.2-mysql

RUN mkdir -p /run/php

# Just some helpful utils
RUN apt install -y vim git wget curl procps htop

RUN ln -sf /proc/self/fd/2 /var/log/php7.2-fpm.log

#TJ Edit to set locale https://stackoverflow.com/questions/28405902/how-to-set-the-locale-inside-a-debian-ubuntu-docker-container
# Set the locale
RUN apt-get -y install locales
RUN sed -i -e 's/# \(en_US\.UTF-8 .*\)/\1/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN touch /usr/share/locale/locale.alias
RUN locale-gen

# uncomment
RUN sed -i 's/;catch_workers_output/catch_workers_output/' /etc/php/7.2/fpm/pool.d/www.conf
RUN sed -i 's/;log_level/log_level/' /etc/php/7.2/fpm/pool.d/www.conf
RUN sed -i 's/;access\.log = .*/access.log = \/proc\/self\/fd\/2/' /etc/php/7.2/fpm/pool.d/www.conf
RUN grep 'access.log' /etc/php/7.2/fpm/pool.d/www.conf

# Fix envs not being set
# https://github.com/docker-library/php/issues/74
RUN sed -i 's/;clear_env = .*/clear_env = no/' /etc/php/7.2/fpm/pool.d/www.conf

ENTRYPOINT ["php-fpm7.2"]
CMD ["-F"]
