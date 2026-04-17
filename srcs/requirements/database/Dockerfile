FROM alpine:3.22.4

COPY "entrypoint.sh" "/bin/"

RUN mkdir -p /run/mysqld

RUN apk add --no-cache \
    mariadb \
    mariadb-client
    
RUN mariadb-install-db --basedir=/usr --user=mysql --datadir=/var/lib/mysql \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql \
    && chmod +x /bin/entrypoint.sh

COPY "conf/mariadb-server.cnf" "/etc/my.cnf.d/"

EXPOSE 3306         

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["mariadbd"]