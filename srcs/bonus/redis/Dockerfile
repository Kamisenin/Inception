from alpine:3.21.5

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache redis

COPY conf/redis.conf /etc/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis.conf"]