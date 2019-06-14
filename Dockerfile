FROM plone:4.3-alpine

ADD ./src /plone/instance/src/

RUN mv /plone/instance/src/custom_buildout.cfg /plone/instance/ && \ 
    mv /plone/instance/src/docker-initialize.py / 

RUN apk --update add --no-cache --virtual .build-deps \
        mariadb-dev libffi-dev build-base && \
    buildout -c /plone/instance/custom_buildout.cfg && \
    chown -R plone:plone /plone /data \
    && apk del .build-deps \
    && rm -rf /plone/buildout-cache/downloads/*

RUN apk -q --no-cache add mariadb-dev
