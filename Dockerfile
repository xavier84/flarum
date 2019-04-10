FROM debian
MAINTAINER Xavier  <xavier@ratxabox.ovh>

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get -y install apt-transport-https lsb-release ca-certificates wget && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
    apt-get update && apt-get install -q -y curl \
                          git \
                          libcurl3\
                          mysql-server \
                          nginx \
                          openssl \
                          php7.2 \
                          php7.2-curl \
                          php7.2-fpm \
                          php7.2-gd \
                          php7.2-dom \
                          php7.2-mysql \
                          php7.2-mbstring \
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
