# docker-caddy1

Run [Caddy][1] webserver inside a docker container.

## Usage

### Command line

```sh
docker ...  # FIXME
```

### docker-compose

```yaml
version: "3"

services:
  caddy:
    image: #FIXME
    restart: always
    volumes:
      - ./Caddyfile:/etc/Caddyfile:ro
      - caddy:/root/.caddy
    ports:
     - "80:80"
     - "443:443"

volumes:
  caddy:
```

[1]: https://github.com/caddyserver/caddy
