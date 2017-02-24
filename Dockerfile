FROM debian:8.2
MAINTAINER Xavier  <xavier@ratxabox.ovh>

# System
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get install -q -y curl \
                          git \
                          libcurl3\
                          mysql-server \
                          nginx \
                          openssl \
                          php5 \
                          php5-curl \
                          php5-fpm \
                          php5-gd \
                          php5-mysql \
                          \
                          && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer

# Flarum
RUN composer create-project flarum/flarum /opt/flarum --stability=beta && cd /opt/flarum && composer require milescellar/flarum-ext-french
# Nginx
RUN rm -rf /etc/nginx/sites-enabled/*
ADD nginx-flarum.conf /etc/nginx/sites-enabled/flarum.conf

# MySQL
RUN service mysql start &&

# Init script
ADD run-flarum.sh /run-flarum.sh
RUN chmod +x /run-flarum.sh

# Persistence
VOLUME ["/var/lib/mysql", "/var/www/flarum"]

# Ports
EXPOSE 80

# Run
CMD /run-flarum.sh
