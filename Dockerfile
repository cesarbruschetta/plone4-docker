FROM python:2.7-slim-stretch

ENV PIP=9.0.3 \
    ZC_BUILDOUT=2.11.4 \
    SETUPTOOLS=39.1.0 \
    WHEEL=0.31.1 \
    PLONE_MAJOR=4.3 \
    PLONE_VERSION=4.3.18 \
    PLONE_MD5=c9932e919254a2799b0e340b2ecbda9b


LABEL plone=$PLONE_VERSION \
    os="debian" \
    os.version="9" \
    name="Plone 4.3" \
    description="Plone image, based on buildout script" \
    maintainer="Cesar Augusto"

RUN useradd --system -m -d /plone -U -u 500 plone \
 && mkdir -p /plone/instance/src 

COPY source/* /plone/instance/

RUN buildDeps="dpkg-dev gcc libbz2-dev libc6-dev libjpeg62-turbo-dev libopenjp2-7-dev libpcre3-dev libssl-dev libtiff5-dev libxml2-dev libxslt1-dev wget zlib1g-dev git libffi-dev default-libmysqlclient-dev" \
 && runDeps="gosu libjpeg62 libopenjp2-7 libtiff5 libxml2 libxslt1.1 lynx netcat poppler-utils rsync wv default-libmysqlclient-dev nano" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && wget -q -O Plone.tgz https://launchpad.net/plone/$PLONE_MAJOR/$PLONE_VERSION/+download/Plone-$PLONE_VERSION-UnifiedInstaller.tgz \
 && echo "$PLONE_MD5 Plone.tgz" | md5sum -c - \
 && tar -xzf Plone.tgz \
 && cp -r ./Plone-$PLONE_VERSION-UnifiedInstaller/base_skeleton/* /plone/instance/ \
 && pip install pip==$PIP setuptools==$SETUPTOOLS zc.buildout==$ZC_BUILDOUT wheel==$WHEEL \
 && cd /plone/instance \
 && buildout \
 && rm -rf bin/buildout \
 && chown -R plone:plone /plone \
 && apt-get purge -y --auto-remove $buildDeps \
 && apt-get install -y --no-install-recommends $runDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /plone/buildout-cache/downloads/* \
 && rm -rf /plone/downloads/*

COPY scripts/* /
RUN chmod +x /docker-entrypoint.sh /docker-initialize.py

EXPOSE 8080
WORKDIR /plone/instance

HEALTHCHECK --interval=1m --timeout=5s --start-period=1m \
  CMD nc -z -w5 127.0.0.1 8080 || exit 1

ENTRYPOINT ["/bin/bash", "-c", "/docker-entrypoint.sh"]
CMD ["console"]