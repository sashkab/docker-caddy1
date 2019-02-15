FROM golang:1.11.5-alpine3.9 as builder

LABEL description="caddy server" maintainer="github@compuix.com"

ENV GOPATH /go
ENV VERSION v0.11.4
ENV ME -c user.name='dockerfile' -c user.email='dockerfile@localhost'

RUN set -xe \
    && apk add --no-cache git musl-dev \
    && go get github.com/mholt/caddy/caddy \
    && go get github.com/caddyserver/builds \
    && go get github.com/pyed/ipfilter \
    && cd $GOPATH/src/github.com/mholt/caddy/caddy \
    && git checkout "${VERSION}" \
    && grep "EnableTelemetry =" caddymain/run.go \
    && sed -i.old -e 's/EnableTelemetry = true/EnableTelemetry = false/' caddymain/run.go \
    && grep "EnableTelemetry =" caddymain/run.go \
    && echo -e 'package caddymain\n\n import _ "github.com/pyed/ipfilter"' >> caddymain/plugins.go \
    && git ${ME} commit -am "Disabled telemetry; enabled http.ipfilter" \
    && git ${ME} tag -m "fake tag" "${VERSION}.ultimate" \
    && go run build.go \
    && /go/src/github.com/mholt/caddy/caddy/caddy --version


FROM alpine:3.9
RUN apk --no-cache add ca-certificates

COPY --from=builder /go/src/github.com/mholt/caddy/caddy/caddy /usr/bin/caddy
COPY index.html /www/index.html

VOLUME /root/.caddy /www
WORKDIR /www

EXPOSE 80 443

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["-agree", "--conf", "/etc/Caddyfile", "--log", "stdout"]
