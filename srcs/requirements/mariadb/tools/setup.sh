#!/bin/bash
set -e

# Initialize MariaDB data directory if it's not already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# Start MariaDB temporarily in background with networking enabled
mysqld &
sleep 5  # wait for it to be ready

echo "Creating database and user..."

# Unset MYSQL_HOST so mariadb client connects via socket (localhost)
unset MYSQL_HOST

mariadb <<-EOSQL
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';
    FLUSH PRIVILEGES;
EOSQL

echo "viendo la vida pasar"
# Gracefully stop the temporary MariaDB server
#mysqladmin shutdown

echo "pues al final no era para tanto"

# Wait until MariaDB has fully stopped before continuing
#while pgrep mariadbd >/dev/null; do
#    echo "bucle infinito"
#    sleep 1
#done

killall mysqld || true
sleep 3

echo "Starting MariaDB server..."

# Start MariaDB as the main foreground process (PID 1 in container)
mysqld



#Wordpress