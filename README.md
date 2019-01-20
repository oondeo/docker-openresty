# docker-openresty
Nginx docker with openresty and naxsi support.

To run it:
``` bash
docker run -e DOMAIN_PROD="mydomain.com" -e DOMAIN_DEV="mydomain.127.0.0.1.xip.io" -p 8081:8081 -p 8080:8080   oondeo/openresty

http://localhost:8081/verynginx/index.html

user: verynginx
pass: verynginx
```

All request to DOMAIN_DEV are transformed in DOMAIN_PROD.
All environment variables that start with NGINXCONF_ replace the configuration value. Example:
```
NGINXCONF_client_max_body_size=64M
```


