#!/bin/dash
NGINX_CONF_PATH=${NGINX_CONF_PATH:-/opt/app-root/etc/nginx.conf}

while true
do
    inotifywait -e CREATE -r /etc/nginx/conf.d
    sleep 4
    conf-nginx
    nginx -s reload -c $NGINX_CONF_PATH
done