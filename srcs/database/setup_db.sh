#!/bin/sh

set -e

echo "Generating MariaDB configuration..."

echo "Starting MariaDB in skip-grant-tables mode..."
mariadbd-safe --skip-grant-tables --user=root &
echo "Waiting for MariaDB to start..."
while ! mariadb-admin ping --silent 2>/dev/null; do
    sleep 1
done

echo "Modifying root password..."
mariadb -u mysql << SQL
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
FLUSH PRIVILEGES;
SQL

echo "Initializing Wordpress Database..."

mariadb -u root -p"$DB_ROOT_PASSWORD"  << SQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
SQL

echo "Stopping MariaDB..."
mariadb-admin -u root -p"$DB_ROOT_PASSWORD" shutdown

echo "Initialization done..."

echo "Starting MariaDB normally..."
exec "$@"