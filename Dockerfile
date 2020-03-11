FROM golang:1.14-alpine as builder

ENV GOPATH /go
COPY ./src /src
WORKDIR /src

RUN set -xe \
    && apk add --no-cache git musl-dev \
    && go mod download \
    && go install \
    && "${GOPATH}/bin/caddy" -version

FROM alpine:3.11

LABEL description="caddy server" maintainer="github@compuix.com" version="2020.03.11"

RUN apk --no-cache add ca-certificates

COPY --from=builder /go/bin/caddy /usr/bin/caddy
COPY index.html /www/index.html

VOLUME /root/.caddy
WORKDIR /www

EXPOSE 80 443

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["-agree", "--conf", "/etc/caddy/Caddyfile", "--log", "stdout"]
