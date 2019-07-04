# Docker para Plone 4.3

[![](https://images.microbadger.com/badges/image/cesarbruschetta/plone.svg)](https://microbadger.com/images/cesarbruschetta/plone "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/cesarbruschetta/plone.svg)](https://microbadger.com/images/cesarbruschetta/plone "Get your own version badge on microbadger.com")

# Caracteristicas

- Plone 4.3.18
- RelStorage
- MemCache
- Sentry
- Modulos:
    - [cabinformatica.skin](https://github.com/cesarbruschetta/cabinformatica.skin/)
    - [myportal.skin](https://github.com/cesarbruschetta/myportal.skin/)

## Instalação

Utilize o arquivo `docker-compose.yml` para alterar as variavles de ambiente e poder configurar a docker, e utilize o comando abaixo para iniciar as docker (mysql e plone)

```bash
    $ docker-compose up -d
```


## Referencias
- https://github.com/BriefyHQ/plone
- https://github.com/plone/plone.docker/blob/master/4.3/4.3.18/




