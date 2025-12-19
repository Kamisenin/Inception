FROM alpine:3.21.5

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache \
		nginx \
		openssl \
    && rm -rf /var/cache/apk/*

COPY conf/wordpress.conf /etc/nginx/http.d
COPY conf/adminer.conf /etc/nginx/http.d

RUN mkdir -p /etc/nginx/ssl/ \
	&& apk add openssl \
	&& openssl req \
		-x509 \
		-nodes \
		-out /etc/nginx/ssl/wordpress.crt \
		-keyout /etc/nginx/ssl/wordpress.key \
		-subj "/C=FR/ST=NA/L=Angouleme/O=42/OU=42/CN=csenelle.42.fr/UID=csenelle" \
	&& openssl req \
		-x509 \
		-nodes \
		-out /etc/nginx/ssl/adminer.crt \
		-keyout /etc/nginx/ssl/adminer.key \
		-subj "/C=FR/ST=NA/L=Angouleme/O=42/OU=42/CN=csenelle.adminer.fr/UID=csenelle_adminer"

EXPOSE 443

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]