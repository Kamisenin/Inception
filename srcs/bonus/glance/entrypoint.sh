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

chmod +x /var/run/docker.sock

export SECRET_KEY=$(/var/glance/glance secret:make)

check_var "SECRET_KEY" $SECRET_KEY
check_var "GLANCE_ADMIN" $GLANCE_ADMIN
check_var "GLANCE_PASSWD" $GLANCE_PASSWD

exec /var/glance/glance --config /var/glance/glance.yml