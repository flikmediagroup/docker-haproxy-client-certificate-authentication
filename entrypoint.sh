#!/bin/sh
set -eo pipefail

# create certificate dir
mkdir -p /usr/local/etc/haproxy/certs

# Write CA and server certificate from env to files
echo "$SSL_CA_PEM" > /usr/local/etc/haproxy/certs/ca.pem
echo "$SSL_SERVER_PEM" > /usr/local/etc/haproxy/certs/server.pem

echo "Writing new haproxy config from template"
sed -e "s|%APP_HOST%|$APP_HOST|" < /tmp/haproxy.cfg.tmpl > /usr/local/etc/haproxy/haproxy.cfg

haproxy -f /usr/local/etc/haproxy/haproxy.cfg
