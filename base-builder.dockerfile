# vim: set syntax=dockerfile:

FROM python:3.9.23-slim-bullseye

ARG ckan_tag=ckan-2.10.8

RUN apt-get update && \
  apt-get install -y --no-install-recommends build-essential python3-dev libpq-dev git-core libmagic1

WORKDIR /usr/local/src

ADD https://github.com/ckan/ckan/archive/refs/tags/${ckan_tag}.tar.gz .

RUN mkdir ckan && tar xzf ${ckan_tag}.tar.gz -C ckan --strip-components=1

RUN ( cd /usr/local/src/ckan && \
    pip install 'setuptools>=66.1,<66.2' && pip install -r requirements.txt && python setup.py install; )

