# Dockerfile - alpine
# https://github.com/openresty/docker-openresty

ARG RESTY_IMAGE_BASE="openresty/openresty"
ARG RESTY_IMAGE_TAG="alpine"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

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



# Copy nginx configuration files
COPY root/ /
COPY verynginx/verynginx /opt/verynginx/verynginx

RUN rm -rf /etc/nginx && ln -s /opt/app-root/etc /etc/nginx

# Reset permissions of modified directories and add default user
RUN apk add --no-cache dash bash && ln -s /usr/bin/dash /bin/dash \
    && useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
      -c "Default Application User" default  || true \
    && adduser -u 1001 -s /bin/dash -G root -h ${HOME} default || true \   
    && chown -R 1001:0 /opt/app-root /opt/verynginx /usr/local/openresty/nginx \
    && chmod -R g+w /opt/app-root /opt/verynginx /usr/local/openresty/nginx \
    && chmod ug+s /opt/app-root/* \
    && mkdir -p ${HOME}/.pki/nssdb \
    && chown -R 1001:0 ${HOME}/.pki \
    && chown -R 1001:0 /var/log \
    && chmod -R 777 /var/log \
    && chmod 777 /var/run && chmod 775 /run \
    && chmod ug+s /run /var/run \
    && chown 1001 /var/run /run 

USER 1001

EXPOSE 8080 8081 8443

CMD ["/usr/libexec/s2i/bin/run"]
#https://github.com/masterzen/nginx-upload-progress-module