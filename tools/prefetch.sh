#!/bin/bash

set -euo pipefail

URL="${1:-}"

if [ -z "$URL" ]; then
    echo "Usage: $0 <tarball_url>" >&2
    exit 1
fi

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

curl -fsSL "$URL" -o "$tmp_dir/source.tar.gz"
sha256sum "$tmp_dir/source.tar.gz" | awk '{print $1}'
