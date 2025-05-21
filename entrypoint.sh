#!/bin/bash

cat >/etc/dnsmasq.conf <<EOF
# Listen on localhost and all interfaces
interface=lo
interface=*
bind-interfaces

# DNS settings
no-resolv
no-hosts

# Forward .myco domains to Mycoria's DNS server (without brackets)
server=/myco/fd00::b909

# Forward everything else to Docker's DNS
server=127.0.0.11

# Don't cache negative responses
neg-ttl=0
cache-size=0

# Enable IPv6
enable-ra

# Enable logging
log-queries=extra
log-facility=/var/log/dnsmasq.log
EOF

dnsmasq -d &

echo "Starting Mycoria..."
mycoria run --config /etc/mycoria/config.yaml &

echo "Waiting for Mycoria to initialize..."
sleep 5

socat TCP6-LISTEN:$EXPOSE_PORT,fork,reuseaddr TCP4:$EXPOSE_SERVICE:$EXPOSE_SERVICE_PORT &

socat TCP-LISTEN:$EXPOSE_REMOTE_PORT,bind=0.0.0.0,fork,reuseaddr TCP6:[$EXPOSE_REMOTE_HOST]:$EXPOSE_PORT &

wait
