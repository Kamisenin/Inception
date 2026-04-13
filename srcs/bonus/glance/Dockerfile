FROM alpine:3.21.5

COPY conf/glance.yml /var/glance/glance.yml
COPY entrypoint.sh  /bin/entrypoint.sh

RUN chmod +x /bin/entrypoint.sh

WORKDIR /var/glance

RUN wget https://github.com/glanceapp/glance/releases/download/v0.8.4/glance-linux-amd64.tar.gz -O glance.tar.gz \
    && tar -xzf glance.tar.gz \
    && rm -rf glance.tar.gz \
    && chmod +x /var/glance/glance

EXPOSE 8081

ENTRYPOINT ["/bin/entrypoint.sh"]