FROM debian
MAINTAINER Xavier  <xavier@ratxabox.ovh>

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get install -q -y curl \
                          git \
                          libcurl3\
                          mysql-server \
                          nginx \
                          openssl \
                          php7.2 \
                          php7.2-curl \
                          php7.2-fpm \
                          php7.2-gd \
                          php7.2-mysql \
                          \
                          && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer

RUN composer create-project flarum/flarum /opt/flarum --stability=beta && cd /opt/flarum && composer require milescellar/flarum-ext-french

RUN rm -rf /etc/nginx/sites-enabled/*
ADD nginx.conf /etc/nginx/sites-enabled/flarum.conf

RUN service mysql start

ADD run.sh /run.sh
RUN chmod +x /run.sh

VOLUME ["/var/lib/mysql", "/var/www/flarum"]

EXPOSE 80

CMD /run.sh
