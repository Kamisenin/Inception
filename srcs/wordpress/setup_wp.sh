#!/bin/sh

set -e

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

check_var() {
    local var_name="$1"
    local var_value="$2"
    
    if [ -z "$var_value" ]; then
        log "ERROR: Environment variable $var_name has not been set or is empty"
        exit 1
    fi
}

check_var "WORDPRESS_DB" "$WORDPRESS_DB"
check_var "WORDPRESS_DB_USER" "$WORDPRESS_DB_USER"
check_var "WORDPRESS_DB_PASSWORD" "$WORDPRESS_DB_PASSWORD"
check_var "WORDPRESS_DB_HOST" "$WORDPRESS_DB_HOST"

check_var "WORDPRESS_TITLE" "$WORDPRESS_TITLE"
check_var "WORDPRESS_ADMIN" "$WORDPRESS_ADMIN"
check_var "WORDPRESS_ADMIN_PASSWORD" "$WORDPRESS_ADMIN_PASSWORD"
check_var "WORDPRESS_ADMIN_EMAIL" "$WORDPRESS_ADMIN_EMAIL"

check_var "WORDPRESS_USER" "$WORDPRESS_USER"
check_var "WORDPRESS_USER_EMAIL" "$WORDPRESS_USER_EMAIL"
check_var "WORDPRESS_USER_PASSWD" "$WORDPRESS_USER_PASSWD"

if [ -f "/var/www/html/wp-config.php" ]; then
	log "WordPress already installed, skipping installation."
else
	log "wp-config.php not found. Installing and configuring wordpress..."

	log "Downloading WordPress core"
	wp --allow-root core download --path="/var/www/html"

	log "Creating config"
	wp --allow-root config create --path="/var/www/html" \
		--dbname="$WORDPRESS_DB" \
		--dbuser="$WORDPRESS_DB_USER" \
		--dbpass="$WORDPRESS_DB_PASSWORD" \
		--dbhost="$WORDPRESS_DB_HOST" \
		--skip-check

	log "Installing Wordpress core"
	wp --allow-root core install	--path="/var/www/html" \
		--url=csenelle.42.fr \
		--title="$WORDPRESS_TITLE" \
		--admin_user="$WORDPRESS_ADMIN" \
		--admin_password="$WORDPRESS_ADMIN_PASSWORD" \
		--admin_email="$WORDPRESS_ADMIN_EMAIL" \
		--skip-email
	
	wp --allow-root user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
		--path="/var/www/html" \
		--user_pass="$WORDPRESS_USER_PASSWD" \
		--role='contributor'

	log "Installing Redis plugin"
	wp --allow-root config set WP_REDIS_PORT 6379
	wp --allow-root config set WP_REDIS_HOST redis
	wp --allow-root config set WP_CACHE_KEY_SALT csenelle.42.fr
	wp plugin install redis-cache --activate
	wp --allow-root plugin update --all
	wp --allow-root redis enable
fi

exec php-fpm84 -F