FROM alpine:3.22.4

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache \
		nginx \
		envsubst \
    && rm -rf /var/cache/apk/*

COPY conf/static_page.conf /etc/nginx/http.d

COPY index.template /bin/index.template

COPY entrypoint.sh /bin/entrypoint.sh

RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]