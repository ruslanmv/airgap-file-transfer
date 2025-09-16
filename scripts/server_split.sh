#!/usr/bin/env bash
set -euo pipefail
ENCODED_TXT="${1:?Usage: server_split.sh <encoded.txt> [chunks]}"
CHUNKS="${2:-3}"

python3 src/split_file.py "$ENCODED_TXT" "$CHUNKS"
