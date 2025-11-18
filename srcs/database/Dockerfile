FROM alpine:3.22.2

ENV MYSQL_ROOT_PASSWORD=b2br
ENV WORDPRESS_PASSWORD=wppasswd
ENV WORDPRESS_DB=wordpress
ENV WORDPRESS_USER:=wpuser

EXPOSE 3306

VOLUME ["var/lib/mysql"]
COPY ["setup.sh", "/var/lib/mysql"]

RUN \
    apk add --no-cache mariadb mariadb-client && \
    chmod +x /var/lib/mysql/setup.sh

ENTRYPOINT ["setup.sh"]
CMD ["mariadb", "--user=mysql", "--datadir=/var/lib/mysql", "--bind-address=0.0.0.0"]