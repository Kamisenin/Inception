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

COPY "setup_umami.sh" "/bin/setup_umami.sh"
RUN chmod +x "/bin/setup_umami.sh"

ENTRYPOINT ["/bin/setup_umami.sh"]

CMD ["pnpm", "next", "start", "-p", "8081"]