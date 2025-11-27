from alpine:3.21.5

EXPOSE 9000

RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
        lighttpd \
        php \
        fcgi \
        php-cgi

COPY conf/lighttpd.conf /etc/lighttpd/

RUN rc-service lighttpd start \
    && rc-update add lighttpd default

RUN apk add --no-cache \
    wget \
    mysql \
    mysql-client \
    php82-mysqli

RUN rc-service lighttpd restart

RUN mkdir -p /usr/share/webapps/ \
    && cd /usr/share/webapps/ \
    && wget https://wordpress.org/latest.tar.gz \
    && tar -xzvf latest.tar.gz \
    && rm latest.tar.gz \
    && chown -R lighttpd /usr/share/webapps/
