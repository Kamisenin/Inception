#!/bin/sh

set -e

chmod +x /var/run/docker.sock
exec /var/glance/glance --config /var/glance/glance.yml