<div align="center">

<img src="./watchtower.jpeg" height="400px"/>

# Watchtower

An automated configuration of my HTPC.

</div>

## 📖 Overview

Control center for my personal media (incl. ~2500 MP3s from the 90s and 00s). Powered by [terraform](https://terraform.io), [ansible](https://ansible.com), [docker](https://docker.com) and a few scripts.

## 🐳 Docker Compose

At the heart of the project is Docker, Docker Compose v2 to be specific. Makes for easy deployment to, and management of, a singular host.

See `docker-compose.yaml` for the services deployed.


## 🧰 Core Components

- [Docker Socket Proxy](https://github.com/Tecnativa/docker-socket-proxy): Secured proxy for Homepage to watch Docker
- [Homepage](https://gethomepage.dev): Easily configurable dashboard with plugins for numerous core components
- [Jellyfin](https://jellyfin.org): Plex competitor. Currently running comparisons. One advantage for Jellyfin is the lack of a SaaS and support for more media types (comics, audiobooks)
- [Node Exporter](https://github.com/prometheus/node_exporter): Presents host resource metrics to be consumed by Prometheus and displayed by Grafana
- [Plex](https://plex.tv): Organizes and streams media
- [Traefik](https://traefik.io): Reverse proxy for serving other components with HTTPS enabled URLs. Using Let's Encrypt for quick and easy HTTPS certificates.
- [Watchtower](https://containrrr.dev/watchtower/): No relation. 😅 Keeps an eye on colocated containers and updates them while I'm (hopefully) sleeping.

## 📋 Prerequisites

### Environment File

`.env` stores common variables to be referenced by virtually all docker compose services via `env_file` parameter. See sample below.

```sh
# general
DOMAIN="example.net"
DOMAIN_EXT="example.com"
HOST_IP=192.168.1.2
PGID=1000
PUID=1000
TZ="America/New_York"

# apps
JELLYFIN_API_KEY=REDACTED
OVERSEER_API_KEY=REDACTED
PLEX_API_KEY=REDACTED
PORTAINER_API_KEY=REDACTED
PROWLARR_API_KEY=REDACTED
RADARR_API_KEY=REDACTED
SONARR_API_KEY=REDACTED
TAUTULLI_API_KEY=REDACTED

# cloudflare
CF_API_EMAIL=REDACTED
CF_API_KEY=REDACTED

# gluetun
OPENVPN_USER=REDACTED
OPENVPN_PASSWORD=REDACTED

# grafana
GRAFANA_USER=REDACTED
GRAFANA_PASSWORD=REDACTED

# qbittorrent
QBITTORRENT_USER=REDACTED
QBITTORRENT_PASSWORD=REDACTED

# media
BOOKS_PATH=/mnt/hulkpool/books
DOWNLOADS_PATH=/mnt/hulkpool/downloads
MISC_PATH=/mnt/hulkpool/misc
MOVIES_PATH=/mnt/hulkpool/movies
MUSIC_PATH=/mnt/hulkpool/music
TVSHOWS_PATH=/mnt/whirlpool/tvshows

# optional (if deploying containers remotely and without systemd)
DOCKER_HOST_IP=${HOST_IP}
DOCKER_HOST="ssh://root@${DOCKER_HOST_IP}"
```

## 🚀 Deployment

Ideally, `git clone` this repo at `/etc/watchtower` on the target host.

To deploy locally:

```sh
make install
```

To deploy remotely, ensure:

- Host is accessible via SSH
- Host has docker compose installed
- SSH params are tweaked (`MaxStartups 200`)
- `DOCKER_HOST` is set locally

```sh
make start
```
