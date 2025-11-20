#!/bin/sh

set -e

echo "Generating MariaDB configuration..."


    echo "Modifying root password..."
    SQL_FILE="/tmp/root.sql"
    cat > "$SQL_FILE" << SQL
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EXIT
SQL

    mysqld_safe --skip-grant-tables --user=root < $SQL_FILE

    rm -f "$SQL_FILE"

    echo "Initializing Wordpress Database..."

    SQL_FILE="/tmp/init.sql"
    cat > "$SQL_FILE" << SQL
CREATE DATABASE IF NOT EXISTS `${WORDPRESS_DB}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${WORDPRESS_USER}'@'%' IDENTIFIED BY '${WORDPRESS_PASSWORD}';
GRANT ALL PRIVILEGES ON `${WORDPRESS_DB}`.* TO '${WORDPRESS_USER}'@'%';
FLUSH PRIVILEGES;
EXIT
SQL

    mariadbd < "$SQL_FILE"
    rm -f "$SQL_FILE"

    echo "Initialization done..."

echo "Starting MariaDB..."
exec "$@"