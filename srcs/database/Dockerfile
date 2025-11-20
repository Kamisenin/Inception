FROM alpine:3.20.0

EXPOSE 3306

COPY "setup_db.sh" "/bin/"

RUN mkdir -p /run/mysqld

RUN \
    apk add --no-cache mariadb mariadb-client && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql && \
    chmod +x /bin/setup_db.sh

COPY "conf/mariadb-server.cnf" "/etc/my.cnf.d/"
    
ENTRYPOINT ["/bin/setup_db.sh"]
CMD ["mariadb"]

# ENTRYPOINT ["sleep"]
# CMD ["infinity"]
