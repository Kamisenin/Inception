from alpine:3.21.5

EXPOSE 8080

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache \
    php84-session \
    php84-mysqli \
    php84-pdo_mysql \
    php84-json \
    php84 \
    php84-mbstring

RUN mkdir -p /var/www/html/adminer

WORKDIR /var/www/html/adminer

RUN wget -O index.php https://github.com/vrana/adminer/releases/download/v5.4.1/adminer-5.4.1-en.php

CMD ["php84", "-S", "0.0.0.0:8080", "-t", "/var/www", "/var/www/adminer.php"]