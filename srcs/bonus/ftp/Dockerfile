FROM alpine:3.21.5

RUN apk add vsftpd

COPY conf/vsftpd.conf /etc/vsftpd.conf

COPY setup_vsftpd.sh /bin/setup_vsftpd.sh
RUN chmod +x /bin/setup_vsftpd.sh

EXPOSE 21

EXPOSE 21210-21220

ENTRYPOINT ["/bin/setup_vsftpd.sh"]