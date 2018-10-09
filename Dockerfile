FROM haproxy:1.8.9-alpine
RUN apk add --no-cache tini
COPY entrypoint.sh /
COPY haproxy.cfg.tmpl /tmp/
COPY reqrep.tmpl /tmp/
WORKDIR /

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/entrypoint.sh"]
