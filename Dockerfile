FROM openresty/openresty:jessie

ENV HOME=/opt/app-root/src \
    PATH=/opt/app-root/src/bin:/opt/app-root/bin:/usr/local/bin:$PATH \
    NGINX_CACHE=0
RUN mkdir -p $HOME /opt/app-root/etc 

COPY common/ /opt/app-root/etc/nginx
COPY scripts/ /usr/local/bin/

RUN ln /usr/sbin/nologin /sbin/nologin && rm -rf /etc/nginx \
    && ln -s /opt/app-root/etc/nginx /etc/nginx \
    && ln -s /usr/local/openresty/nginx/modules /etc/nginx/modules \
    && mkdir -p /opt/app-root/var/log/nginx /opt/app-root/var/run \
    && ln -sf /opt/app-root/var/log/nginx /var/log/nginx \
    && rm -rf  /usr/local/openresty/nginx/logs \
    && ln -sf /opt/app-root/var/log/nginx /usr/local/openresty/nginx/logs \
    && ln -sf /var/run/nginx.pid /usr/local/openresty/nginx/logs/nginx.pid \
    && ln -sf /var/run/nginx.lock /usr/local/openresty/nginx/logs/nginx.lock \
    && rm -rf /var/cache/nginx && mkdir -p /var/cache && ln -sf /tmp /var/cache/nginx \
  	&& ln -sf /dev/stdout /var/log/nginx/access.log \
  	&& ln -sf /dev/stderr /var/log/nginx/error.log    

WORKDIR $HOME

CMD [ "run" ]

EXPOSE 8080 8081

# Reset permissions of modified directories and add default user
RUN mkdir -p ${HOME} \
    && chmod 777 /run /var/run \
    && adduser --system --uid 1001 --gid 0 --home ${HOME} --shell /usr/sbin/nologin default \
    && chown -R 1001:0 /opt/app-root \
    && mkdir -p ${HOME}/.pki/nssdb \
    && chown -R 1001:0 ${HOME}/.pki 

USER 1001  