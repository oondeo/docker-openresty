#!/bin/dash
while true
do
    inotifywait -m -r /etc/nginx/conf.d
    conf-nginx
    sleep 4
done