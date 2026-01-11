#!/bin/bash

set -euo pipefail

BASE_URL="${1:-}"

if [ -z "$BASE_URL" ]; then
    echo "Usage: $0 <base_url>" >&2
    echo "Example: $0 https://example.tld" >&2
    exit 1
fi

check_status() {
    local url="$1"
    local expected="$2"
    local status

    status=$(curl -sS -o /dev/null -w "%{http_code}" "$url")
    if ! [[ "$expected" =~ (^|,)${status}(,|$) ]]; then
        echo "Unexpected status for $url: $status (expected $expected)" >&2
        return 1
    fi
}

check_status "${BASE_URL}/" "200,301,302"
check_status "${BASE_URL}/admin/" "200,301,302"
check_status "${BASE_URL}/api/health" "200"

ws_status=$(curl -sS -o /dev/null -w "%{http_code}" "${BASE_URL}/socket.io/?EIO=4&transport=websocket")
if [ "$ws_status" != "101" ] && [ "$ws_status" != "400" ]; then
    echo "Unexpected websocket status: $ws_status" >&2
    exit 1
fi

echo "Smoke tests passed."
