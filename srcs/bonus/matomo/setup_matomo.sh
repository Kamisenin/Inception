#!/bin/bash

set -e

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [MATOMO] - $1"
}

check_var() {
    local var_name="$1"
    local var_value="$2"
    
    if [ -z "$var_value" ]; then
        log "ERROR: Environment variable $var_name has not been set or is empty"
        exit 1
    fi
}

# Vérifier les variables d'environnement
check_var "MATOMO_DB_HOST" "$MATOMO_DB_HOST"
check_var "MATOMO_DB_NAME" "$MATOMO_DB_NAME"
check_var "MATOMO_DB_USER" "$MATOMO_DB_USER"
check_var "MATOMO_DB_PASSWORD" "$MATOMO_DB_PASSWORD"
check_var "MATOMO_ADMIN_USER" "$MATOMO_ADMIN_USER"
check_var "MATOMO_ADMIN_PASSWORD" "$MATOMO_ADMIN_PASSWORD"
check_var "MATOMO_ADMIN_EMAIL" "$MATOMO_ADMIN_EMAIL"
check_var "MATOMO_SITE_NAME" "$MATOMO_SITE_NAME"
check_var "MATOMO_SITE_URL" "$MATOMO_SITE_URL"

# Créer le répertoire partagé s'il n'existe pas
mkdir -p /shared

if [ -f "/var/www/html/config/config.ini.php" ]; then
    log "Matomo already installed, skipping installation."
else
    log "Installing Matomo..."
    
    # Télécharger Matomo
    log "Downloading Matomo latest version"
    curl -fsSL https://builds.matomo.org/matomo-latest.zip -o /tmp/matomo.zip
    unzip -q /tmp/matomo.zip -d /var/www/
    mv /var/www/matomo/* /var/www/html/
    rm -rf /var/www/matomo /tmp/matomo.zip
    
    # Attendre que la base de données soit prête
    log "Waiting for database to be ready..."
    until mariadb -h"$MATOMO_DB_HOST" -u"$MATOMO_DB_USER" -p"$MATOMO_DB_PASSWORD" -e "SELECT 1" > /dev/null 2>&1; do
        sleep 2
    done
    
    # Créer la base de données Matomo si elle n'existe pas
    log "Creating Matomo database if not exists..."
    mariadb -h"$MATOMO_DB_HOST" -u"$MATOMO_DB_USER" -p"$MATOMO_DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MATOMO_DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
    
    # Installer Matomo via console
    log "Installing Matomo core via console"
    php /var/www/html/console core:install \
        --db-host="$MATOMO_DB_HOST" \
        --db-username="$MATOMO_DB_USER" \
        --db-password="$MATOMO_DB_PASSWORD" \
        --db-name="$MATOMO_DB_NAME" \
        --admin-username="$MATOMO_ADMIN_USER" \
        --admin-password="$MATOMO_ADMIN_PASSWORD" \
        --admin-email="$MATOMO_ADMIN_EMAIL" \
        --site-name="$MATOMO_SITE_NAME" \
        --site-url="$MATOMO_SITE_URL" \
        --do-not-drop-db \
        --no-interaction
    
    log "Matomo core installed successfully"
    
    # Installer ExtraTools plugin
    log "Installing ExtraTools plugin..."
    cd /var/www/html/plugins
    git clone https://github.com/matomo-org/plugin-ExtraTools.git ExtraTools
    chown -R nobody:nobody /var/www/html/plugins/ExtraTools
    
    # Activer ExtraTools
    log "Activating ExtraTools plugin..."
    php /var/www/html/console plugin:activate ExtraTools || log "ExtraTools activation warning (peut être ignoré si déjà activé)"
    
    # Générer le token d'authentification
    log "Generating auth token for WordPress integration..."
    AUTH_TOKEN=$(php /var/www/html/console user:token-auth "$MATOMO_ADMIN_USER" 2>/dev/null | tail -n1)
    
    if [ -z "$AUTH_TOKEN" ]; then
        log "ERROR: Failed to generate auth token"
        exit 1
    fi
    
    # Sauvegarder le token pour WordPress
    echo "$AUTH_TOKEN" > /shared/matomo-token.txt
    log "Auth token saved to /shared/matomo-token.txt"
    
    # Obtenir l'ID du site (normalement 1 pour le premier site)
    SITE_ID=$(php /var/www/html/console site:list --format=json 2>/dev/null | grep -o '"idsite":"[0-9]*"' | head -n1 | grep -o '[0-9]*')
    echo "$SITE_ID" > /shared/matomo-siteid.txt
    log "Site ID: $SITE_ID saved to /shared/matomo-siteid.txt"
    
    # Configurer les permissions
    chown -R nobody:nobody /var/www/html
    chmod -R 755 /var/www/html
    
    log "Matomo installation completed successfully!"
fi

# Démarrer PHP-FPM sur le port 8081
log "Starting PHP-FPM on port 8081..."
exec php-fpm84 -F
