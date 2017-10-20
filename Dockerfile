FROM oondeo/alpine


ENV RESTY_CONFIG_OPTIONS="\
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--http-client-body-temp-path=/tmp/client_temp \
--http-proxy-temp-path=/tmp/proxy_temp \
--http-fastcgi-temp-path=/tmp/fastcgi_temp \
--http-uwsgi-temp-path=/tmp/uwsgi_temp \
--without-http_scgi_module \
--user=nginx \
--group=root \
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
    --with-md5-asm \
    --with-pcre-jit \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-mail=dynamic \
    --with-mail_ssl_module \
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

ENV HOME=/opt/app-root/src \
    PATH=/opt/app-root/src/bin:/opt/app-root/bin:/usr/local/bin:$PATH \
    NGINX_CACHE=0
RUN mkdir -p $HOME /opt/app-root/etc 

COPY common/ /opt/app-root/etc/nginx
COPY scripts/ /usr/local/bin/

RUN rm -rf /etc/nginx \
    && ln -s /opt/app-root/etc/nginx /etc/nginx \
    && rm /etc/nginx/modules \
    && ln -s /usr/local/openresty/nginx/modules /etc/nginx/modules

VOLUME [ "/opt/app-root/etc/nginx/conf.d" , $HOME ]

WORKDIR $HOME

CMD [ "run" ]

EXPOSE 8080 8081

# Reset permissions of modified directories and add default user
RUN mkdir -p ${HOME} \
    && chmod 777 /run \
    && adduser -u 1001 -S -G root -h ${HOME} -s /sbin/nologin default \
    && chown -R 1001:0 /opt/app-root \
    && mkdir -p ${HOME}/.pki/nssdb \
    && chown -R 1001:0 ${HOME}/.pki 

USER 1001  