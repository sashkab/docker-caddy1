FROM golang:1.12.0-alpine3.9 as builder

LABEL description="caddy server" maintainer="github@compuix.com"

ENV GOPATH /go
ENV GO111MODULE "on"
COPY ./src /src
WORKDIR /src

RUN set -xe \
    && apk add --no-cache git musl-dev \
    && go mod download \
    && go build -v -o ./caddy -ldflags '-s -w' ./caddy.go \
    && ./caddy -version

FROM alpine:3.9
RUN apk --no-cache add ca-certificates

COPY --from=builder /src/caddy /usr/bin/caddy
COPY index.html /www/index.html

VOLUME /root/.caddy /www
WORKDIR /www

EXPOSE 80 443

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["-agree", "--conf", "/etc/Caddyfile", "--log", "stdout"]
