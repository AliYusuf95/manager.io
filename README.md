# Manager.io docker

Manager is free accounting software for small business. Updated periodically using github actions

## Image

- **Docker Hub:** [aliyusuf/manager.io](https://hub.docker.com/r/aliyusuf/manager.io)
- **GitHub Registry (ghcr.io):** [ghcr.io/aliyusuf95/manager.io](https://github.com/AliYusuf95/manager.io/pkgs/container/manager.io)

## APP

Dockerized [manager.io](https://www.manager.io) server edition from the offical manager.io [repository](https://github.com/Manager-io/Manager)

The data is stored on a external volume `/data`

## RUNNING

#### Simple run:

```
$ docker run -d ghcr.io/aliyusuf95/manager.io
```

#### Preferred way to run:

```bash
$ docker run -d \
  --name Manager \
  -p 8080:8080 \
  -v /path/to/my/data:/data \
  --restart=unless-stopped \
  ghcr.io/aliyusuf95/manager.io:latest
```

```yaml
services:
  manager:
    image: ghcr.io/aliyusuf95/manager.io:latest
    container_name: manager
    ports:
      # host:container
      - 8080:8080
    volumes:
      - /path/to/my/data:/data
    restart: unless-stopped
```

Your Manager will be accessible on http://dockerhost:8080

## UPDATING

<Warning>Only use this if your data is on external volume!</Warning>

#### Manual backup from Manager:

```
Open the business name -> click Backup
```

#### Manual updating:

```
$ docker stop Manager
$ docker rm Manager
$ docker pull ghcr.io/aliyusuf95/manager.io:latest
$ docker run -d ... (Preferred way to run)
```

Running docker prefered way, all files should already be in place. If not, restore from manual backup.

#### Automated updating:

<Warning>Use this on your own risk!</Warning>

Add `--label=com.centurylinklabs.watchtower.enable=true` to run arguments of your manager like this:

```
$ docker run -d \
  --name Manager \
  -p 8080:8080 \
  -v /path/to/my/data:/data \
  --restart=unless-stopped \
  --label=com.centurylinklabs.watchtower.enable=true \
  ghcr.io/aliyusuf95/manager.io:latest
```

and then start an updater container which will only update your Manager container, every time new version is released

```
$ docker run -d \
  --name Manager_Watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart=unless-stopped \
  --label-enable \
  ghcr.io/aliyusuf/watchtower:latest
```
