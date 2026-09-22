# vim: set syntax=dockerfile:

FROM python:3.9.23-slim-bullseye

ARG ckan_tag=ckan-2.10.8

RUN apt-get update && \
  apt-get install -y --no-install-recommends libpq5 libmagic1 && \
  rm -rf /var/lib/apt/lists/*
 
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/src/ckan/wsgi.py /usr/local/src/ckan/wsgi.py

RUN addgroup --gid 1000 ckan && \
  adduser --disabled-password --uid 1000 --gid 1000 --gecos '' ckan && \
  mkdir -vp /etc/ckan/default && chown ckan:ckan -vR /etc/ckan/

RUN ( ckan_install_dir=/usr/local/lib/python3.9/site-packages/ckan-${ckan_tag##ckan-}-py3.9.egg/ckan/; \
  chown root:ckan -vR ${ckan_install_dir}/public && chmod 0775 -vR ${ckan_install_dir}/public; )

USER ckan
ENV CKAN_INI=/etc/ckan/default/ckan.ini

RUN ckan generate config ${CKAN_INI} 

WORKDIR /var/lib/ckan/default/
