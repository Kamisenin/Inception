#!/bin/sh

echo "Generating MariaDB configuration..."

if [ -d "/var/lib/mysql/mysql" ]; then
    
    echo "MariaDB already configured..."
    
else
SQL_FILE="/tmp/init.sql"
cat > "$SQL_FILE" << SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS `${WORDPRESS_DB}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${WORDPRESS_USER}'@'%' IDENTIFIED BY '${WORDPRESS_PASSWORD}';
GRANT ALL PRIVILEGES ON `${WORDPRESS_DB}`.* TO '${WORDPRESS_USER}'@'%';
FLUSH PRIVILEGES;
SQL

mariadbd --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock --bootstrap < "$SQL_FILE"
rm -f "$SQL_FILE"
fi

echo "Starting MariaDB..."
exec "$@"