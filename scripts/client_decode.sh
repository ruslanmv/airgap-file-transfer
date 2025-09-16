#!/usr/bin/env bash
set -euo pipefail

TXT="${1:?Usage: client_decode.sh <encoded_or_merged.txt> [outdir]}"
OUTDIR="${2:-out}"

python3 src/decode.py "$TXT"

ZIP="${TXT/_encoded.txt/_decoded.zip}"

if command -v unzip >/dev/null 2>&1; then
  unzip -o "$ZIP" -d "$OUTDIR"
else
  # Python fallback if unzip isn't available
  python3 - "$ZIP" "$OUTDIR" <<'PY'
import sys, os, zipfile
zip_path, outdir = sys.argv[1], sys.argv[2]
os.makedirs(outdir, exist_ok=True)
with zipfile.ZipFile(zip_path) as zf:
    zf.extractall(outdir)
print(f"Extracted to: {outdir}")
PY
fi

echo "Done. Restored under: $OUTDIR"
