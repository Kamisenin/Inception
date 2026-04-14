FROM alpine:3.21.5

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache \
		nginx \
		curl \
		openssl \
    && rm -rf /var/cache/apk/*

COPY conf/server.conf /etc/nginx/http.d

RUN mkdir -p /etc/nginx/ssl/ \
	&& apk add openssl \
	&& openssl req \
		-x509 \
		-nodes \
		-out /etc/nginx/ssl/wordpress.crt \
		-keyout /etc/nginx/ssl/wordpress.key \
		-subj "/C=FR/ST=NA/L=Angouleme/O=42/OU=42/CN=csenelle.42.fr/UID=csenelle"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]