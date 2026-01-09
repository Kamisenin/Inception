FROM alpine:3.21.5

RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
        php84 \
        php84-fpm \
        php84-mysqli \
        php84-json \
        php84-openssl \
        php84-curl \
        php84-zlib \
        php84-xml \
        php84-phar \
        php84-intl \
        php84-dom \
        php84-xmlreader \
        php84-ctype \
        php84-session \
        php84-mbstring \
        php84-gd \
        php84-zip \
        php84-exif \
        php84-fileinfo \
        php84-tokenizer \
        php84-simplexml \
        php84-pdo \
        php84-pdo_mysql \
        curl \
        git \
        unzip \
        mariadb-client \
        bash

RUN mv /usr/bin/php84 /usr/bin/php

COPY conf/php.ini /etc/php84/php.ini
COPY conf/www.conf /etc/php84/php-fpm.d/

WORKDIR /var/www/html

COPY setup_matomo.sh /bin/setup_matomo.sh
RUN chmod +x /bin/setup_matomo.sh

EXPOSE 8081

ENTRYPOINT ["/bin/setup_matomo.sh"]
