FROM alpine:3.21.5

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache \
		nginx \
    && rm -rf /var/cache/apk/*

COPY conf/static_page.conf /etc/nginx/http.d
COPY index.html /var/www/html/index.html

ENTRYPOINT ["nginx", "-g", "daemon off;"]