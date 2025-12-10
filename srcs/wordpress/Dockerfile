FROM alpine:3.21.5

EXPOSE 9000

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
        curl \
        mariadb-client

RUN mv /usr/bin/php84 /usr/bin/php

#We get Wordpress CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \ 
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY conf/php.ini /etc/php84/php.ini
COPY conf/www.conf /etc/php84/php-fpm.d/

COPY setup_wp.sh /bin/setup_wp.sh
RUN chmod +x /bin/setup_wp.sh

WORKDIR /var/www/html

ENTRYPOINT ["/bin/setup_wp.sh"]