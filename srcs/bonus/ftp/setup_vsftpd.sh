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

check_var "FTP_USER" "$FTP_USER"
check_var "FTP_PASSWD" "$FTP_PASSWD"

if [ -f /etc/vsftpd.init ]; then
    log "Vsftp already initialized"

else
    log "Creating user $FTP_USER with password $FTP_PASSWD"
    adduser -D $FTP_USER
    echo "$FTP_USER:$FTP_PASSWD" | chpasswd

    log "Setting up permissions"
    chown -R "$FTP_USER:$FTP_USER" /var/www/html

    echo $FTP_USER >> /etc/vsftpd.userlist
    touch /etc/vsftpd.init
fi

log "Starting vsftpd"
exec vsftpd "/etc/vsftpd.conf"