# vim: set syntax=dockerfile:

FROM python:3.9.23-slim-bullseye

ARG ckanapi_tag=4.8

RUN pip install ckanapi==${ckanapi_tag}
