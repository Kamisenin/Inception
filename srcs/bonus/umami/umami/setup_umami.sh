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

check_var "UMAMI_USER" "$UMAMI_USER"
check_var "UMAMI_USER_PASSWD" "$UMAMI_USER_PASSWD"
check_var "UMAMI_DB" "$UMAMI_DB"

export DATABASE_URL="postgresql://$UMAMI_USER:$UMAMI_USER_PASSWD@postgre_sql/$UMAMI_DB"

if [ ! -f "/bin/umami/init_manifesto" ]; then
    log "Initializing umami build"

    pnpm exec prisma generate
    pnpm next build
    touch "/bin/umami/init_manifesto"
else
    log "Already initialized, skipping build..."
fi

log "Starting umami..."
exec "$@"