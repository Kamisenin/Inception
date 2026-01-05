FROM alpine:3.21.5

COPY "setup_db.sh" "/bin/"

RUN mkdir -p /run/mysqld

RUN \
    apk add --no-cache mariadb mariadb-client && \
    mariadb-install-db --basedir=/usr --user=mysql --datadir=/var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
    chmod +x /bin/setup_db.sh

COPY "conf/mariadb-server.cnf" "/etc/my.cnf.d/"

EXPOSE 3306         

ENTRYPOINT ["/bin/setup_db.sh"]
CMD ["mariadbd"]