# Watchtower

Configurations for my HTPC.

## Prerequisites

### Environment File

`.env` stores common variables to be referenced by virtually all docker compose services via `env_file`. See example below.

```
DOMAIN=example.com
PUID=1000
PGID=1000
TZ="America/New_York"

# media
CONFIG_PATH=/var/lib/plex
DOWNLOADS_PATH=/mnt/media/downloads
MISC_PATH=/mnt/media/misc
MOVIES_PATH=/mnt/media/movies
MUSIC_PATH=/mnt/media/music
TVSHOWS_PATH=/mnt/media/tvshows

# plex
HOST_IP=192.168.0.2
```

## Deployment

Mount your storage before deploying.

### Local

```sh
./setup.sh prepare
./setup.sh deploy
```

### Remote

```sh
# update `ansible/hosts.yaml` before proceeding
cd ansible/
ansible-playbook deploy.yaml
```
