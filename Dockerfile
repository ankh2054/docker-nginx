FROM alpine:3.6

ENV ALPINE_VERSION=3.6


ENV PACKAGES="\
  dumb-init \
  musl \
  linux-headers \
  build-base \
  ca-certificates \
  supervisor \
  mariadb-dev \
  nginx \
  nano \
  php7 \
  php7-session \
  php7-simplexml \
  php7-zlib \
  php7-fpm \
  php7-cli \
  php7-gd  \
  php7-mcrypt \
  php7-pdo_mysql \
  php7-mysqli \
  php7-curl \
  php7-xml \
  php7-json \
"

RUN echo \
  # replacing default repositories with edge ones
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" > /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \

  # Add the packages, with a CDN-breakage fallback if needed
  && apk add --no-cache $PACKAGES || \
    (sed -i -e 's/dl-cdn/dl-4/g' /etc/apk/repositories && apk add --no-cache $PACKAGES) \

  # turn back the clock -- so hacky!
  && echo "http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/main/" > /etc/apk/repositories 


# Add files
ADD files/nginx.conf /etc/nginx/nginx.conf
ADD files/php-fpm.conf /etc/php/7.0/fpm/


# Entrypoint
ADD start.sh /
RUN chmod u+x /start.sh
CMD /start.sh
