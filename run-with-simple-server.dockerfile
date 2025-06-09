# vim: set syntax=dockerfile:

FROM runtime

COPY --chmod=0755 simple-wsgi-server.py /usr/local/bin/simple-wsgi-server

ENV PYTHONPATH=/usr/local/src/ckan

ENTRYPOINT [ "simple-wsgi-server" ]
CMD [ "wsgi:application" ]
