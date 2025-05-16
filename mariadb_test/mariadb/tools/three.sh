#!/bin/bash
set -e

# Initialize DB directory if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# Start MariaDB server in background (safe mode skips networking at first)
mysqld_safe --skip-networking &
sleep 5  # Give the server time to start

# Connect as root locally (do NOT use MYSQL_HOST here!)
echo "Setting up initial database and user..."
mariadb -u root <<-EOSQL
  CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
  CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
  GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
  FLUSH PRIVILEGES;
EOSQL

# Kill background server
killall mariadbd || true
sleep 3

# Start MariaDB normally (foreground)
exec mysqld

