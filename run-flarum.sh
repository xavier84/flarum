#!/bin/sh

echo "Starting flarum..."

if [ ! -f "/var/www/flarum/admin.php" ];then
cp -r /opt/flarum/* /var/www/flarum
chown www-data:www-data -R /var/www/flarum && chmod 777 -R /var/www/flarum
mysql_install_db
/etc/init.d/mysql start
mysql -u root -e 'create database flarum'
fi


echo "Stargin mysql"
/etc/init.d/mysql start

echo "Starting php"
/etc/init.d/php5-fpm start

echo "Starting nginx"
/etc/init.d/nginx start


tail -f /var/log/nginx/access.log
