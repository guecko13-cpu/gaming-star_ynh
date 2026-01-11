#!/bin/bash

set -euo pipefail

domain="${1:-example.tld}"
path="${2:-/casino-games-fun}"

base_url="https://${domain}${path}"

curl -fsS "${base_url}/" >/dev/null

admin_status=$(curl -k -s -o /dev/null -w "%{http_code}" "${base_url}/admin/")
if [ "$admin_status" != "200" ] && [ "$admin_status" != "302" ] && [ "$admin_status" != "401" ] && [ "$admin_status" != "403" ]; then
    echo "Unexpected status for admin page: ${admin_status}" >&2
    exit 1
fi

health_status=$(curl -k -s -o /dev/null -w "%{http_code}" "${base_url}/api/health")
if [ "$health_status" != "200" ]; then
    echo "Unexpected status for healthcheck: ${health_status}" >&2
    exit 1
fi
