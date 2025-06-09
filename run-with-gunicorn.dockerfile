# vim: set syntax=dockerfile:

FROM runtime

USER root
RUN pip install 'gunicorn==23.0.0'

# NOTE option `--preload` is helpful for troubleshooting errors at startup 
# (i.e. while loading the WSGI app)
ENV GUNICORN_CMD_ARGS="--preload --log-level=info --workers=1 --threads=1 --access-logfile=- --error-logfile=- --capture-output"

USER ckan
ENTRYPOINT [ "gunicorn", "--bind=0.0.0.0:5000", "--chdir=/usr/local/src/ckan" ]
CMD [ "wsgi:application" ]
