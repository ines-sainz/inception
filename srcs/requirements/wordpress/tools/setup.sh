#!/bin/bash
set -e

echo "wordpress iniciado"

# Wait for MariaDB to be ready
until mysqladmin ping -h"$MYSQL_HOST" --silent; do
	echo "Waiting for MariaDB..."
	sleep 2
done

mkdir -p /run/php

# Copy WordPress files if not already present
if [ ! -f /var/www/html/index.php ]; then
	echo "Copying Wordpress to /var/www/html"
	cp -a /tmp/wp/. /var/www/html/
fi

cd /var/www/html

# Install WordPress using WP-CLI if not already installed
if ! wp core is-installed --allow-root; then
	echo "Setting up wp-config.php and installing WordPress..."

	wp config create \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="$MYSQL_HOST" \
		--locale=es_ES \
		--allow-root

	wp core install \
		--url="https://$DOMAIN_NAME" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email \
		--allow-root

	echo "Creating additional WordPress user..."
	wp user create "$WP_USER" "$WP_USER_EMAIL" \
		--user_pass="$WP_USER_PASSWORD" \
		--role=author \
		--allow-root
else
	echo "WordPress already installed"
fi

# Set correct permissions
chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F

