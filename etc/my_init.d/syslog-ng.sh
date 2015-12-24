#! /bin/bash

[[ "$DJANGO_SETTINGS_MODULE" == "config.prod" ]] && rm /etc/syslog-ng/conf.d/mota.conf || true

