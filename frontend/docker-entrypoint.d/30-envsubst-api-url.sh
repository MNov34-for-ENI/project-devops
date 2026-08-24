#!/bin/sh
set -eu

grep -rl "REPLACE_AT_BUILD_TIME" /usr/share/nginx/html 2>/dev/null | \
    xargs -r sed -i "s|REPLACE_AT_BUILD_TIME|${API_URL}|g"
