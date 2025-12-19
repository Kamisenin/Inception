#!/bin/sh

set -e

echo "Generating MariaDB configuration..."

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}


if [ -f "/var/lib/mysql/mysql/init_manifesto" ]; then
	log "Database already exist, skipping"
else
    log "Initializing Wordpress Database..."

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
    log "Initialization done..."
    touch /var/lib/mysql/mysql/init_manifesto
fi

log "Starting MariaDB normally..."
exec "$@"