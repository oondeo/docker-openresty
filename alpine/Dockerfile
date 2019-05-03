# Dockerfile - alpine
# https://github.com/openresty/docker-openresty

#ARG RESTY_IMAGE_BASE="openresty/openresty"
#ARG RESTY_IMAGE_TAG="alpine"
ARG OPENRESTY_VERSION="1.15.8.1"

#FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}
FROM openresty/openresty:alpine

ENV SUMMARY="Nginx, resty and naxsi image with standar modules"	\
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
      version="7" \
      release="1" \
      maintainer="OONDEO <info@oondeo.es>"

ENV \
    # DEPRECATED: Use above LABEL instead, because this will be removed in future versions.
    STI_SCRIPTS_URL=image:///usr/libexec/s2i \
    # Path to be used in other layers to place s2i scripts into
    STI_SCRIPTS_PATH=/usr/libexec/s2i/bin

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

# Copy nginx configuration files
COPY root/root /
COPY verynginx/verynginx /opt/verynginx/verynginx
COPY etc /opt/app-root/etc
COPY s2i/bin $STI_SCRIPTS_PATH
RUN mkdir -p /opt/app-root/var/nginx && rm -rf /etc/nginx && ln -s /opt/app-root/var/nginx /etc/nginx \
    && mkdir -p /opt/dashboard && ln -s /opt/verynginx/verynginx/dashboard /opt/dashboard/verynginx \
    && rm -rf /usr/local/openresty/nginx/conf && ln -s /opt/app-root/etc /usr/local/openresty/nginx/conf

# Reset permissions of modified directories and add default user
RUN apk add --no-cache dash bash tini inotify-tools && ln -s /usr/bin/dash /bin/dash \
    && /usr/bin/docker-footer \   
    && chown -R 1001:0 /opt/verynginx /usr/local/openresty/nginx \
    && chmod -R g+w /opt/verynginx /usr/local/openresty/nginx 


USER 1001

EXPOSE 8080 8081

ENTRYPOINT ["/sbin/tini", "-g" ,"--", "/usr/bin/container-entrypoint"]
CMD [ "run" ]
#https://github.com/masterzen/nginx-upload-progress-module