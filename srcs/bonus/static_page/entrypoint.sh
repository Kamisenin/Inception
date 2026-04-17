#!/bin/sh

set -e

mkdir -p /var/www/html

envsubst < /bin/index.template > /var/www/html/index.html
exec "$@"