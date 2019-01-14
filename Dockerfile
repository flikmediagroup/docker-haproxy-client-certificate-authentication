FROM haproxy:1.8.17-alpine
RUN set -exo pipefail \
    && apk add --no-cache \
        tini \
        rsyslog \
    && mkdir -p /etc/rsyslog.d \
    && touch /var/log/haproxy.log \
    && ln -sf /dev/stdout /var/log/haproxy.log
COPY entrypoint.sh /
COPY haproxy.cfg.tmpl /tmp/
COPY reqrep.tmpl /tmp/
COPY rsyslog.conf /etc/rsyslog.d/
WORKDIR /

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/entrypoint.sh"]
