#!/bin/sh

set -e

echo "Generating MariaDB configuration..."

# if [ -d "/var/lib/mysql/mysql" ]; then
# 	echo "Database already exist, skipping"
# else

#     echo "Starting MariaDB in skip-grant-tables mode..."
#     mariadbd-safe --skip-grant-tables --user=root --bootstrap
#     echo "Waiting for MariaDB to start..."
    
#     for i in $(seq 1 30); do
#         mariadb-admin ping --silent && break
#         echo "Waiting for mariadb to be up ($i/30)..."
#         sleep 1
#     done

#     if ! mariadb-admin ping --silent; then
#         echo "MariaDB failed to start, exiting."
#         exit 1
#     fi

#     echo "Modifying root password..."
#     mariadb -u mysql << SQL
# FLUSH PRIVILEGES;
# ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
# FLUSH PRIVILEGES;
# SQL

#     echo "Initializing Wordpress Database..."

#     mariadb -u root -p"$DB_ROOT_PASSWORD"  << SQL
# CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
# CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWD}';
# GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
# FLUSH PRIVILEGES;
# SQL

#     echo "Stopping MariaDB..."
#     mariadb-admin -u root -p"$DB_ROOT_PASSWORD" shutdown


#     echo "Initialization done..."

    mariadbd -u mysql --bootstrap << EOF
        FLUSH PRIVILEGES;
        ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
        FLUSH PRIVILEGES;
        CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWD}';
        GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
        CREATE USER 'health'@'%' IDENTIFIED BY 'health';
        FLUSH PRIVILEGES;
EOF
# fi

echo "Starting MariaDB normally..."
exec "$@"