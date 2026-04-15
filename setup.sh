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

check_var "DATA_PATH" $DATA_PATH
check_var "DOMAIN_NAME" $DOMAIN_NAME

if [ ! -d "${DATA_PATH}/data/db" ]; then
    mkdir -p "${DATA_PATH}/data/db"
fi


if [ ! -d "${DATA_PATH}/data/wordpress" ]; then
    mkdir -p "${DATA_PATH}/data/wordpress"
fi

if [ ! -d "${DATA_PATH}/data/umami" ]; then
    mkdir -p "${DATA_PATH}/data/umami"
fi

if [ ! -d "${DATA_PATH}/data/postgre" ]; then
    mkdir -p "${DATA_PATH}/data/postgre"
fi