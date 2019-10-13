#!/bin/dash
NGINX_CONF_PATH=${NGINX_CONF_PATH:-/opt/app-root/etc}
NGINX_CONF_WATCH_PATH=${NGINX_CONF_WATCH_PATH:-''}
WATCH_STR="-r $NGINX_CONF_PATH"

for i in $(echo $NGINX_CONF_WATCH_PATH | tr ',' ' ')
do
    WATCH_STR="$WATCH_STR -r \"$i\""
done
echo $WATCH_STR
while true
do
    inotifywait -e CREATE $WATCH_STR
    sleep 4
    conf-nginx
    nginx -s reload -c $NGINX_CONF_PATH/nginx.conf
done