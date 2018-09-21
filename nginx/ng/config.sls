# nginx.ng.config
#
# Manages the main nginx server configuration file.

{% from 'nginx/ng/map.jinja' import nginx, sls_block with context %}

nginx_log_dir:
  file.directory:
    - name: /var/log/nginx
    - user: root
    - group: root
    - mode: 755

{% if 'source_path' in nginx.server.config %}
{% set source_path = nginx.server.config.source_path %}
{% else %}
{% set source_path = 'salt://nginx/ng/files/nginx.conf' %}
{% endif %}
nginx_config:
  file.managed:
    {{ sls_block(nginx.server.opts) }}
    - name: {{ nginx.lookup.conf_file }}
    - source: {{ source_path }}
    - template: jinja
{% if 'source_path' not in nginx.server.config %}
    - context:
        config: {{ nginx.server.config|json() }}
{% endif %}
