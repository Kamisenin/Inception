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

if [ ! -f "$PGDATA/PG_VERSION" ]; then
    su-exec postgres initdb -D "$PGDATA"
    su-exec postgres pg_ctl -D "$PGDATA" start

    # Attendre que PostgreSQL soit prêt
    until su-exec postgres pg_isready; do sleep 1; done

    # Créer user et base
    su-exec postgres createuser "$UMAMI_USER"
    su-exec postgres createdb -O "$UMAMI_USER" "$UMAMI_DB"
    su-exec postgres psql << EOF
    ALTER USER "$UMAMI_USER" WITH ENCRYPTED PASSWORD '$UMAMI_USER_PASSWD';
EOF
    su-exec postgres pg_ctl -D "$PGDATA" stop
    log "Initialization done..."
else
    log "Postgre already Initialized, skipping..."
fi

log "Starting Postgresql server..."
exec "exec su-exec postgres postgres -D \"$PGDATA\""