#!/bin/sh

set -e

if [ -f "/var/www/html/wp-config.php" ]; then
	echo "WordPress already installed, skipping installation."
else
	echo "wp-config.php not found. Installing and configuring wordpress..."

	echo "Downloading WordPress core"
	wp --allow-root core download --path="/var/www/html"

	echo "Creating config"
	wp --allow-root config create --path="/var/www/html" \
		--dbname=$WORDPRESS_DB \
		--dbuser=$WORDPRESS_USER \
		--dbpass=$WORDPRESS_PASSWORD \
		--dbhost=$WORDPRESS_DB_HOST \
		--skip-check

	echo "Installing Wordpress core"
	wp --allow-root core install	--path="/var/www/html" \
		--url=$WORDPRESS_URL \
		--title=$WORDPRESS_TITLE \
		--admin_user=$WORDPRESS_ADMIN \
		--admin_password=$WORDPRESS_ADMIN_PASSWORD \
		--admin_email=$WORDPRESS_ADMIN_EMAIL \
		--skip-email
	
	--allow-root user create	--path="/var/www/html" \
		$WORDPRESS_USER $WORDPRESS_USER_EMAIL \
		--user_pass=$WORDPRESS_USER_PASSWD \
		--role='contributor'
fi

exec "php-fpm84 -F"