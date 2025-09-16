#!/usr/bin/env bash
set -euo pipefail
FOLDER="${1:-payload_folder}"
ZIP="${2:-$(basename "$FOLDER").zip}"

python3 src/zip_folder.py "$FOLDER" -o "$ZIP"
python3 src/encode.py "$ZIP"
