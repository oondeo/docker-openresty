#!/bin/dash
NGINX_CONF_PATH=${NGINX_CONF_PATH:-/opt/app-root/etc/nginx.conf}

while true
do
    inotifywait -m -r /etc/nginx/conf.d
    conf-nginx
    nginx -s reload -c $NGINX_CONF_PATH
    sleep 4
done