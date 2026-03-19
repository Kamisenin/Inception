FROM alpine:3.21.5

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache \
    postgresql17 \
    postgresql17-contrib \
    su-exec

ENV PGDATA="/var/lib/postgresql/data"

COPY "entrypoint.sh" "/bin/entrypoint.sh"
RUN chmod +x "/bin/entrypoint.sh"

EXPOSE 5432

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["su-exec", "postgres", "postgres", "-D", "/var/lib/postgresql/data"]