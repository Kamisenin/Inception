#!/bin/sh

set -e

chmod +x /var/run/docker.sock

export SECRET_KEY=$(/var/glance/glance secret:make)
exec /var/glance/glance --config /var/glance/glance.yml