# vim: set syntax=dockerfile:

FROM runtime

COPY --chmod=0755 simple-wsgi-server.py /usr/local/bin/simple-wsgi-server

USER root
RUN apt-get update && apt-get install -y vim curl jq ipython3
RUN chown ckan:ckan -R /usr/local/lib/python3.9/site-packages/ckan*

USER ckan
ENV PYTHONPATH=/usr/local/src/ckan
ENTRYPOINT [ "simple-wsgi-server" ]
CMD [ "wsgi:application" ]
