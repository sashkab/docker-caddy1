FROM alpine:3.6

LABEL description="caddy server"
LABEL maintainer="github@compuix.com"

RUN set -xe \
    && apk add --no-cache curl tar \
    && curl "https://caddyserver.com/download/linux/amd64?license=personal" | tar --no-same-owner -C /usr/bin/ -xz caddy

COPY index.html /www/index.html

VOLUME /root/.caddy /www
WORKDIR /www

EXPOSE 80 443

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]
