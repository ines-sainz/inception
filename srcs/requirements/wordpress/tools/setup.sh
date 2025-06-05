#!/bin/bash
# Exit the script immediately if a command exits with a non-zero status
set -e

# Print a message indicating the script has started
echo "wordpress initiated"

# Wait until the MariaDB server is accepting connections
until mysqladmin ping -h"$MYSQL_HOST" --silent; do
	echo "Waiting for MariaDB..."
	sleep 2
done

# Ensure the PHP-FPM runtime directory exists
mkdir -p /run/php

# Copy WordPress files to the web root if not already present
if [ ! -f /var/www/html/index.php ]; then
	echo "Copying Wordpress to /var/www/html"
	cp -a /tmp/wp/. /var/www/html/
fi

# Change directory to WordPress root
cd /var/www/html

# Check if WordPress is already installed
if ! wp core is-installed --allow-root; then
	echo "Setting up wp-config.php and installing WordPress..."

	# Generate the wp-config.php file with database credentials and settings
	wp config create \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="$MYSQL_HOST" \
		--locale=es_ES \
		--allow-root

	# Install WordPress core with the given admin details and site URL
	wp core install \
		--url="https://$DOMAIN_NAME" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email \
		--allow-root

	# Create an additional non-admin WordPress user
	echo "Creating additional WordPress user..."
	wp user create "$WP_USER" "$WP_USER_EMAIL" \
		--user_pass="$WP_USER_PASSWORD" \
		--role=author \
		--allow-root
else
	# If WordPress is already installed, just notify
	echo "WordPress already installed"
fi

# Set the correct permissions on the WordPress directory
chown -R www-data:www-data /var/www/html

# Start PHP-FPM in foreground mode (keep container running)
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
