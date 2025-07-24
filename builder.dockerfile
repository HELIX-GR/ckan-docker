# vim: set syntax=dockerfile:

FROM base-builder

ARG ckanext_hierarchy_tag="heallink-0.1" ckanext_oauth2_tag="heallink-0.1" hdx_ckan_tag="heallink-0.1"

ADD https://github.com/HELIX-GR/ckanext-hierarchy/archive/refs/tags/${ckanext_hierarchy_tag}.tar.gz ./ckanext-hierarchy.tar.gz
ADD https://github.com/HELIX-GR/ckanext-oauth2/archive/refs/tags/${ckanext_oauth2_tag}.tar.gz ./ckanext-oauth2.tar.gz
ADD https://github.com/HELIX-GR/hdx-ckan/archive/refs/tags/${hdx_ckan_tag}.tar.gz ./hdx-ckan.tar.gz

# needed for requirements.txt of hdx-ckan
RUN pip install setuptools~=57.5.0

RUN mkdir ckanext-hierarchy && tar xzf ./ckanext-hierarchy.tar.gz -C ckanext-hierarchy --strip-components=1 && \
  (cd ckanext-hierarchy && python setup.py install) && \
  rm -v ./ckanext-hierarchy.tar.gz

RUN mkdir ckanext-oauth2 && tar xzf ./ckanext-oauth2.tar.gz -C ckanext-oauth2 --strip-components=1 && \
  (cd ckanext-oauth2 && python setup.py install) && \
  rm -v ./ckanext-oauth2.tar.gz

RUN mkdir hdx-ckan && tar xvf ./hdx-ckan.tar.gz -C hdx-ckan --strip-components=1 && \
  (cd hdx-ckan && pip install -r requirements.txt --upgrade-strategy only-if-needed) && \
  (cd hdx-ckan/ckanext-ytp-request && python setup.py install) && \
  (cd hdx-ckan/ckanext-hdx_pages && python setup.py install) && \
  (cd hdx-ckan/ckanext-hdx_org_group && python setup.py install) && \
  (cd hdx-ckan/ckanext-hdx_package && python setup.py install) && \
  (cd hdx-ckan/ckanext-hdx_search && python setup.py install) && \
  (cd hdx-ckan/ckanext-hdx_user_extra && python setup.py install) && \
  (cd hdx-ckan/ckanext-hdx_users && python setup.py install) && \
  (cd hdx-ckan/ckanext-hdx_theme && python setup.py install) && \
  rm -v ./hdx-ckan.tar.gz
