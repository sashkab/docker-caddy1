# docker-caddy1

Run [Caddy][1] webserver inside a docker container.

## Usage

### Command line

Create directories:

```sh
mkdir www caddy-data
```

```sh
docker run -it --rm -v $(pwd)/Caddyfile:/etc/caddy/Caddyfile \
  -v $(pwd)/caddy-data:/root/.caddy -v $(pwd)/www:/www sashk/docker-caddy1
```

### docker-compose

```yaml
version: "3"

services:
  caddy:
    image: sashk/docker-caddy1
    restart: always
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy:/root/.caddy
      - ./path/to/www:/www
    ports:
     - "80:80"
     - "443:443"

volumes:
  caddy:
```

[1]: https://github.com/caddyserver/caddy
