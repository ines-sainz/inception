#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Check if the MariaDB system tables already exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    # If not, initialize the data directory
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# Start the MariaDB server in the background to perform setup tasks
mysqld &

# Give the server a few seconds to start up
sleep 5

echo "Creating database and user..."

# Ensure the MariaDB client connects via socket instead of trying TCP (localhost)
unset MYSQL_HOST

# Run a block of SQL commands using the MariaDB client
mariadb <<-EOSQL
    -- Create the specified database if it doesn't exist
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    
    -- Create an application user that can connect from any host
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    
    -- Create a root user that can connect locally
    CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    
    -- Grant all privileges on the application database to the app user
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    
    -- Grant full privileges to the root user for local access
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';
    
    -- Reload the privilege tables
    FLUSH PRIVILEGES;
EOSQL

# Stop the MariaDB server after setup (suppress error if it's already stopped)
killall mysqld || true

# Give it a few seconds to shut down cleanly
sleep 3

echo "Starting MariaDB server..."

# Start MariaDB in the foreground so the container keeps running
mysqld
