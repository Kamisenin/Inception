FROM alpine:3.21.5

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache \
		nginx \
		curl \
		openssl \
		envsubst \
    && rm -rf /var/cache/apk/*

COPY conf/server.template /bin/server.template

COPY entrypoint.sh /bin/entrypoint.sh

RUN chmod 777 /bin/entrypoint.sh \
	&& chmod 777 /bin/server.template

RUN mkdir -p /etc/nginx/ssl/ \
	&& apk add openssl \
	&& openssl req \
		-x509 \
		-nodes \
		-out /etc/nginx/ssl/wordpress.crt \
		-keyout /etc/nginx/ssl/wordpress.key \
		-subj "/C=FR/ST=NA/L=Angouleme/O=42/OU=42/CN=${DOMAIN_NAME}/UID=csenelle"

EXPOSE 443

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]