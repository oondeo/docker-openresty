FROM oondeo/alpine


ENV RESTY_CONFIG_OPTIONS="\
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--without-http_scgi_module \
--user=nginx \
--group=nginx \
    --with-file-aio \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_geoip_module=dynamic \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module=dynamic \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-http_xslt_module=dynamic \
    --with-mail \
    --with-mail_ssl_module \
    --with-md5-asm \
    --with-pcre-jit \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads "
#    --with-ipv6 \
#    --with-stream_ssl_preread_module \
#--with-stream_realip_module \
#--with-stream_geoip_module=dynamic \
#--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
#--prefix=/etc/nginx \
#--sbin-path=/usr/sbin/nginx \
#--modules-path=/usr/lib/nginx/modules \
#--conf-path=/etc/nginx/nginx.conf 

COPY build /usr/local/bin/

RUN /usr/local/bin/build

COPY common/* /etc/nginx/

CMD ["nginx", "-g", "daemon off;"]
