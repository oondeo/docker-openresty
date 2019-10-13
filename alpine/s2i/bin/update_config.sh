#!/bin/dash
NGINX_CONF_PATH=${NGINX_CONF_PATH:-/opt/app-root/etc}
NGINX_CONF_WATCH_PATH="${NGINX_CONF_WATCH_PATH} ${NGINX_CONF_PATH}"

while true
do
    inotifywait -e CREATE -r $NGINX_CONF_WATCH_PATH
    sleep 4
    conf-nginx
    nginx -s reload -c $NGINX_CONF_PATH/nginx.conf
done