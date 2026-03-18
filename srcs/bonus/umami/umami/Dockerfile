FROM alpine:3.21.5

RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
    npm \
    git

RUN npm install -g pnpm

RUN git clone "https://github.com/umami-software/umami.git" "/bin/umami"

WORKDIR /bin/umami

RUN pnpm install

EXPOSE 8081

CMD ["/bin/setup_umami.sh"]