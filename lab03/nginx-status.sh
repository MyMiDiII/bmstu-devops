#!/bin/sh
# is active?
echo "nginx_is_active $(systemctl is-active --quiet nginx.service && echo 1 || echo 0)" > /var/lib/node_exporter/nginx-status.prom

# stub_status
STATUS_PAGE=$(curl http://localhost:80/status)

ACTIVE=$(echo $STATUS_PAGE | awk '{print $3}')
ACCEPTS=$(echo $STATUS_PAGE | awk '{print $8}')
HANDLED=$(echo $STATUS_PAGE | awk '{print $9}')
REQUESTS=$(echo $STATUS_PAGE | awk '{print $10}')
READING=$(echo $STATUS_PAGE | awk '{print $12}')
WRITING=$(echo $STATUS_PAGE | awk '{print $14}')
WAITING=$(echo $STATUS_PAGE | awk '{print $16}')

[ -z "$ACTIVE" ] && ACTIVE=0
[ -z "$ACCEPTS" ] && ACCEPTS=0
[ -z "$HANDLED" ] && HANDLED=0
[ -z "$REQUESTS" ] && REQUESTS=0
[ -z "$READING" ] && READING=0
[ -z "$WRITING" ] && WRITING=0
[ -z "$WAITING" ] && WAITING=0

PROM="
nginx_active_connections $ACTIVE\n\
nginx_acceptes_connections $ACCEPTS\n\
nginx_handled_connections $HANDLED\n\
nginx_requests $REQUESTS\n\
nginx_reading_connections $READING\n\
nginx_writing_connections $WRITING\n\
nginx_waiting_connections $WAITING"

echo $PROM >> /var/lib/node_exporter/nginx-status.prom
