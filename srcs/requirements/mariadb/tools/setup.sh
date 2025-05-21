#!/bin/bash
set -e

# Initialize MariaDB data directory if it's not already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# Start MariaDB temporarily in background with networking enabled
mysqld_safe &
sleep 10  # wait for it to be ready

echo "Creating database and user..."

# Unset MYSQL_HOST so mariadb client connects via socket (localhost)
unset MYSQL_HOST

mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \${MYSQL_DATABASE}\;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \${MYSQL_DATABASE}\.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

# Gracefully stop the temporary MariaDB server
mysqladmin -u root shutdown

# Wait until MariaDB has fully stopped before continuing
while pgrep mariadbd >/dev/null; do
    sleep 1
done

echo "Starting MariaDB server..."

# Start MariaDB as the main foreground process (PID 1 in container)
exec mysqld