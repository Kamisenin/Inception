FROM alpine:3.21.5

RUN apk add vsftpd

COPY conf/vsftpd.conf /etc/vsftpd.conf

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

EXPOSE 21

EXPOSE 21210-21220

ENTRYPOINT ["/bin/entrypoint.sh"]
