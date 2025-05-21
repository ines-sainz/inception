#!/bin/bash
set -e

# Initialize MariaDB data directory if it's not already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# Start MariaDB in safe mode without networking
mysqld_safe --skip-networking &
sleep 5

echo "Creating database and user..."

# Unset MYSQL_HOST so mariadb client connects via local socket
unset MYSQL_HOST

mariadb -u root <<-EOSQL
  CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
  CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
  GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
  FLUSH PRIVILEGES;
EOSQL

# Stop the background server
killall mariadbd || true
sleep 3

echo "Starting MariaDB server..."
exec mysqld

