

# Manager.io docker

Manager es un software de contabilidad gratuito para pequeñas empresas. Se actualiza periódicamente mediante GitHub Actions

## Imagen

- **Docker Hub:** [aliyusuf/manager.io](https://hub.docker.com/r/aliyusuf/manager.io)
- **Registro de GitHub (ghcr.io):** [ghcr.io/aliyusuf95/manager.io](https://github.com/AliYusuf95/manager.io/pkgs/container/manager.io)

## APP

Edición servidor de [manager.io](https://www.manager.io) contenedorizada desde el [repositorio](https://github.com/Manager-io/Manager) oficial de manager.io

Los datos se almacenan en un volumen externo `/data`

## EJECUCIÓN

#### Ejecución simple:

```
$ docker run -d ghcr.io/aliyusuf95/manager.io
```

#### Forma recomendada de ejecución:

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

Tu Manager será accesible en http://dockerhost:8080

## ACTUALIZACIÓN

<Warning>¡Solo utiliza esto si tus datos están en un volumen externo!</Warning>

#### Copia de seguridad manual desde Manager:

```
Abre el nombre del negocio -> haz clic en Backup
```

#### Actualización manual:

```
$ docker stop Manager
$ docker rm Manager
$ docker pull ghcr.io/aliyusuf95/manager.io:latest
$ docker run -d ... (Preferred way to run)
```

Al ejecutar Docker de la forma recomendada, todos los archivos ya deberían estar en su lugar. De no ser así, restaura desde la copia de seguridad manual.

#### Actualización automática:

<Warning>¡Úsalo bajo tu propio riesgo!</Warning>

Agrega `--label=com.centurylinklabs.watchtower.enable=true` a los argumentos de ejecución de tu Manager de la siguiente manera:

```
$ docker run -d \
  --name Manager \
  -p 8080:8080 \
  -v /path/to/my/data:/data \
  --restart=unless-stopped \
  --label=com.centurylinklabs.watchtower.enable=true \
  ghcr.io/aliyusuf95/manager.io:latest
```

y luego inicia un contenedor actualizador que solo actualizará tu contenedor de Manager cada vez que se publique una nueva versión

```
$ docker run -d \
  --name Manager_Watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart=unless-stopped \
  --label-enable \
  ghcr.io/aliyusuf/watchtower:latest
```
