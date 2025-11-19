FROM alpine:3.20.0

EXPOSE 3306

VOLUME ["var/lib/mysql"]
COPY ["setup.sh", "/var/lib/mysql/"]

RUN \
    apk add --no-cache mariadb mariadb-client && \
    chown -R mysql:mysql /var/lib/mysql && \
    chmod +x /var/lib/mysql/setup.sh

ENTRYPOINT ["/var/lib/mysql/setup.sh"]
CMD ["mariadbd", "--user=mysql", "--datadir=/var/lib/mysql", "--bind-address=0.0.0.0", "--socket=/run/mysqld/mysqld.sock"]