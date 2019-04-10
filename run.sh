#!/bin/sh

echo "Start flarum..."

if [ ! -f "/var/www/flarum/flarum" ];then
cp -r /opt/flarum/* /var/www/flarum
chown www-data:www-data -R /var/www/flarum && chmod 777 -R /var/www/flarum
mysql_install_db
/etc/init.d/mysql start
mysql -u root -e 'create database flarum'
fi

/etc/init.d/mysql start
/etc/init.d/php7.2-fpm start

/etc/init.d/nginx start


tail -f /var/log/nginx/access.log
