FROM alpine:3.8 as builder

LABEL description="caddy server"
LABEL maintainer="github@compuix.com"

ENV GOPATH /go
RUN set -xe \
    && apk add --no-cache go git musl-dev \
    && go get github.com/mholt/caddy/caddy \
    && go get github.com/caddyserver/builds \
    && cd $GOPATH/src/github.com/mholt/caddy/caddy \
    && git checkout v0.11.0 \
    && grep "enableTelemetry =" caddymain/run.go \
    && sed -i.old -e 's/enableTelemetry = true/enableTelemetry = false/' caddymain/run.go \
    && grep "enableTelemetry =" caddymain/run.go \
    && go run build.go \
    && /go/src/github.com/mholt/caddy/caddy/caddy --version


FROM alpine:3.8
RUN apk --no-cache add ca-certificates

COPY --from=builder /go/src/github.com/mholt/caddy/caddy/caddy /usr/bin/caddy
COPY index.html /www/index.html

VOLUME /root/.caddy /www
WORKDIR /www

EXPOSE 80 443

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["-agree", "--conf", "/etc/Caddyfile", "--log", "stdout"]
