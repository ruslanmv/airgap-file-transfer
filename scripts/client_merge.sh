#!/usr/bin/env bash
set -euo pipefail
BASE="${1:?Usage: client_merge.sh <base_encoded_name.txt> <num_chunks> [merged_output.txt]}"
NUM="${2:?Missing <num_chunks>}"
MERGED="${3:-merged_${BASE}}"

python3 src/merge_files.py "$MERGED" "$BASE" "$NUM"
