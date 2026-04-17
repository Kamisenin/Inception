FROM alpine:3.22.4

RUN apk add vsftpd

COPY conf/vsftpd.conf /etc/vsftpd.conf

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
