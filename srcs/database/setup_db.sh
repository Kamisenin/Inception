#!/bin/sh

set -e

echo "Generating MariaDB configuration..."

echo "$MYSQL_ROOT_PASSWORD and $WORDPRESS_DB and $WORDPRESS_USER and $WORDPRESS_PASSWORD"

echo "Starting MariaDB in skip-grant-tables mode..."
mysqld_safe --skip-grant-tables --user=root &
echo "Waiting for MariaDB to start..."
while ! mysqladmin ping --silent 2>/dev/null; do
    sleep 1
done

echo "Modifying root password..."
mysql -u mysql << SQL
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
SQL

echo "Initializing Wordpress Database..."

mysql -u root -p"$MYSQL_ROOT_PASSWORD"  << SQL
CREATE DATABASE IF NOT EXISTS \`${WORDPRESS_DB}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${WORDPRESS_USER}'@'%' IDENTIFIED BY '${WORDPRESS_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${WORDPRESS_DB}\`.* TO '${WORDPRESS_USER}'@'%';
FLUSH PRIVILEGES;
SQL

echo "Stopping MariaDB..."
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

echo "Initialization done..."

echo "Starting MariaDB normally..."
exec "$@"