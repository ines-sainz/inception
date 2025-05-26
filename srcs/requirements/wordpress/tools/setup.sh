#!/bin/bash

set -e

echo "wordpress iniciado"

#Wait for MariaDB to be ready (simple ping loop)
until mysqladmin ping -h"$MYSQL_HOST" --silent; do
	echo "Waiting for MariaDB..."
	sleep 2
done

mkdir -p /run/php

if [ ! -f /var/www/html/index.php ]; then
	echo "Copying Wordpress to /var/www/html"
	cp -a /tmp/wp/. /var/www/html/
fi

#if [ -z "$(ls -A /var/www/html)" ]; then
#	echo "Copy wordpress to /var/www/html"
#	cp -a /tmp/wp/. /var/www/html/
#fi

#If wp-config.php doesn't exist, generate it
if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Setting up wp-config.php..."

	if [ ! -f /var/www/html/wp-config-sample.php ]; then
		echo "config_error: wp-config-sample.php not found"
		ls -la /var/www/html
		exit 1
	fi

	cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

	sed -i "s/database_name_here/${MYSQL_DATABASE}/" /var/www/html/wp-config.php
	sed -i "s/username_here/${MYSQL_USER}/" /var/www/html/wp-config.php
	sed -i "s/password_here/${MYSQL_PASSWORD}/" /var/www/html/wp-config.php
	sed -i "s/localhost/${MYSQL_HOST}/" /var/www/html/wp-config.php
	sed -i "s/false/true/" /var/www/html/wp-config.php
fi

#Set permissions
chown -R www-data:www-data /var/www/html

echo "start php-fpm"
#Start php-fpm
exec php-fpm7.4 -F
