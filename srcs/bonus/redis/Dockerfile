from alpine:3.21.5

EXPOSE 6379

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache redis

COPY conf/redis.conf /etc/redis.conf

CMD ["redis-server", "/etc/redis.conf"]