#!/bin/sh
set -eo pipefail

# create certificate dir
mkdir -p /usr/local/etc/haproxy/certs

# Write CA and server certificate from env to files
echo "$SSL_CA_PEM" > /usr/local/etc/haproxy/certs/ca.pem
echo "$SSL_SERVER_PEM" > /usr/local/etc/haproxy/certs/server.pem

# If virtual path has been enabled
if [ -n "$VIRTUAL_PATH" ]; then
  echo "Virtual path found: $VIRTUAL_PATH, adding it to configuration"
  VPATH_ACL="acl has_vpath url_beg $VIRTUAL_PATH"
  VPATH_USE_BACKEND="use_backend mybackend if has_vpath"
  sed -e "s|%VIRTUAL_PATH%|$VIRTUAL_PATH|" < /tmp/reqrep.tmpl > /tmp/reqrep.txt

else
  VPATH_ACL=""
  VPATH_USE_BACKEND="default_backend mybackend"
  touch /tmp/reqrep.txt
fi

# Add deny if SSL_VERIFY env var is set
if [ -n "$SSL_VERIFY" ]; then
  echo "SSL_VERIFY set to on, adding it to configuration"
  VERIFY="http-request deny if !{ ssl_c_used 1 } || !{ ssl_c_verify 0 }"
else
  VERIFY=''
fi

echo "Writing new haproxy config from template"
sed -e "s|%APP_HOST%|$APP_HOST|" \
    -e "s|%SSL_VERIFY%|$VERIFY|" \
    -e "s|%VPATH_ACL%|$VPATH_ACL|" \
    -e "s|%VPATH_REQREP%|$(cat /tmp/reqrep.txt)|" \
    -e "s|%VPATH_USE_BACKEND%|$VPATH_USE_BACKEND|" < /tmp/haproxy.cfg.tmpl > /usr/local/etc/haproxy/haproxy.cfg

haproxy -f /usr/local/etc/haproxy/haproxy.cfg
