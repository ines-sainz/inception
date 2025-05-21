#!/bin/bash
set -e

# Initialize MariaDB data directory if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MariaDB data directory..."
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# Start MariaDB in the background
mysqld_safe --skip-networking &
sleep 5  # Wait for startup

# Create database and user
echo "Setting up initial database and user..."
mariadb -u root <<-EOSQL
  CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
  CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
  GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
  FLUSH PRIVILEGES;
EOSQL

# Kill background MariaDB
killall mariadbd
sleep 3

# Start MariaDB in foreground
exec mysqld

