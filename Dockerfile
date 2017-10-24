FROM openresty/openresty:jessie

ENV SUMMARY="Nginx image with standar modules"	\
    DESCRIPTION="The image use scripts and configurations compatible \
        with redhat openshift."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Nginx" \
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
      io.s2i.scripts-url=image:///usr/libexec/s2i \
      com.redhat.component="nginx" \
      name="oondeo/openresty" \
      version="13" \
      release="1" \
      maintainer="OONDEO <info@oondeo.es>"

ENV \
    # DEPRECATED: Use above LABEL instead, because this will be removed in future versions.
    STI_SCRIPTS_URL=image:///usr/libexec/s2i \
    # Path to be used in other layers to place s2i scripts into
    STI_SCRIPTS_PATH=/usr/libexec/s2i

ENV \
    # The $HOME is not set by default, but some applications needs this variable
    HOME=/opt/app-root/src \
    PATH=/opt/app-root/src/bin:/opt/app-root/bin:$STI_SCRIPTS_PATH:$PATH


# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ENV BASH_ENV=/opt/app-root/etc/scl_enable \
    ENV=/opt/app-root/etc/scl_enable \
    XDG_DATA_HOME=$HOME/.local/share \
    DEBIAN_FRONTEND=noninteractive \
    LANG=es_ES.UTF-8 LANGUAGE=es_ES.UTF-8 LC_ALL=es_ES.UTF-8 \
    PROMPT_COMMAND=". /opt/app-root/etc/scl_enable"

# Copy extra files to the image.
COPY ./root/root/ /

#Install tiny on debian 
ENV TINI_VERSION=v0.16.1
RUN cp /bin/sh /sh && apt-get update && apt-get install -y --no-install-recommends curl dash locales \
    && curl -o /sbin/tini -SLk https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && echo $LANG UTF-8 >> /etc/locale.gen \
    && locale-gen \     
    && chmod +x /sbin/tini && rm -rf /var/lib/apt/* /var/tmp/* /tmp/* /var/log/* 

# Directory with the sources is set as the working directory so all STI scripts
# can execute relative to this path.
WORKDIR ${HOME}

ENTRYPOINT ["/sbin/tini", "-g" ,"--", "container-entrypoint"]

ENV NGINX_CACHE=0
RUN mkdir -p $HOME /opt/app-root/etc 

COPY common/ /opt/app-root/etc/nginx
COPY scripts/* $STI_SCRIPTS_PATH/

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
  	&& ln -sf /dev/stderr /var/log/nginx/error.log \
    && ln -sf /tmp/client_body_temp /usr/local/openresty/nginx/client_body_temp \
    && ln -sf /tmp/proxy_temp /usr/local/openresty/nginx/proxy_temp \
    && ln -sf /tmp/fastcgi_temp /usr/local/openresty/nginx/fastcgi_temp \
    && ln -sf /tmp/scgi_temp /usr/local/openresty/nginx/scgi_temp \    
    && ln -sf /tmp/uwsgi_temp  /usr/local/openresty/nginx/uwsgi_temp    

WORKDIR $HOME

CMD [ "$STI_SCRIPTS_PATH/run" ]

EXPOSE 8080 8081

# Reset permissions of modified directories and add default user
RUN mkdir -p ${HOME} \
    && chmod 777 /run /var/run \
    && adduser --system --uid 1001 --gid 0 --home ${HOME} --shell /usr/sbin/nologin default \
    && chown -R 1001:0 /opt/app-root \
    && chmod -R g+w  /opt/app-root \
    && mkdir -p ${HOME}/.pki/nssdb \
    && chown -R 1001:0 ${HOME}/.pki 

USER 1001  