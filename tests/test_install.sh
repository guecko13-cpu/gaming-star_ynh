#!/bin/bash

set -euo pipefail

domain="${1:-example.tld}"
path="${2:-/gaming-star}"

curl -fsS "https://${domain}${path}/" >/dev/null

status=$(curl -k -s -o /dev/null -w "%{http_code}" "https://${domain}${path}/ynh-maintenance/")
if [ "$status" != "401" ] && [ "$status" != "302" ] && [ "$status" != "403" ]; then
    echo "Expected maintenance area to be protected, got status ${status}" >&2
    exit 1
fi
