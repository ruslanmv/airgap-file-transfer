# airgap-file-transfer

A tiny, **offline-friendly** terminal tool for moving folders across **air‑gapped** or highly restricted servers using only:

- stock **Python 3** (no third‑party packages)
- plain **terminal/SSH** copy & paste
- optional `unzip` on the client (Python fallback included)

> **Use case**: Enterprise policies block SCP/SFTP/rsync or outbound internet. You can still move data by copy/pasting text through the terminal.

---

## How it works

Server side:
1) Zip a folder → 2) Base64‑encode it to a `.txt` → 3) Split into N chunk files

Client side:
4) Paste each chunk into files → 5) Merge chunks → 6) Decode back to `.zip` → 7) Extract

```
[folder] -> zip -> base64 .txt -> split -> (copy/paste) -> merge -> decode -> unzip -> [folder]
```

All steps use the Python standard library only.

---

## Quick start

### Requirements
- Python 3 on both server and client
- No internet access required
- Optional: `unzip` on the client (we auto‑fallback to Python)

### 1) On the **server**

```bash
# Choose what to send
FOLDER=payload_folder
ZIP_NAME=mydata.zip
CHUNKS=3

# Zip → Encode → Split
make server-all FOLDER="$FOLDER" ZIP="$ZIP_NAME" CHUNKS="$CHUNKS"
# Output: mydata_encoded.txt_1.txt ... _N.txt
```

Copy each produced chunk file’s content via your terminal to the client (see the copy/paste tip below).

### 2) On the **client**

```bash
# Variables must match what the server used
ENCODED_BASE=mydata_encoded.txt   # base name before _1.txt
CHUNKS=3
MERGED=merged_mydata_encoded.txt  # you can pick another name
OUTDIR=out

# Merge chunks → Decode → Unzip
make client-all ENCODED_BASE="$ENCODED_BASE" CHUNKS="$CHUNKS" MERGED="$MERGED" OUTDIR="$OUTDIR"
```

Your original folder appears under `out/` (or your chosen `OUTDIR`).

---

## Make targets

```bash
# Server side
make zip FOLDER=<folder> ZIP=<name.zip>
make encode ZIP=<name.zip>                    # -> <name>_encoded.txt
make split ENCODED=<name_encoded.txt> CHUNKS=3
make server-all FOLDER=<folder> ZIP=<name.zip> CHUNKS=3

# Client side
make merge ENCODED_BASE=<name_encoded.txt> CHUNKS=3 MERGED=<merged.txt>
make decode TXT=<merged.txt> OUTDIR=<outdir>
make client-all ENCODED_BASE=<...> CHUNKS=<...> MERGED=<...> OUTDIR=<...>

# Utilities
make checksum FILE=<path>                     # SHA256 of a file (stdlib)
```

### Defaults
- `ZIP` defaults to `<FOLDER>.zip`
- `CHUNKS=3`
- `OUTDIR=out`
- `MERGED=merged_<ENCODED>`

---

## Copy/paste tip

On the **server**, for each chunk file (e.g. `mydata_encoded.txt_1.txt`):

```bash
# Show it without line wrapping, then copy with your mouse
less -S mydata_encoded.txt_1.txt
# or:
cat mydata_encoded.txt_1.txt
```

On the **client**, create the file and paste the content between `EOF` markers:

```bash
cat > mydata_encoded.txt_1.txt <<'EOF'
# (paste everything here)
EOF
```

Repeat for `_2.txt`, `_3.txt`, etc.

---

## Integrity check (optional)

You can compare input/output checksums:

```bash
# On server
make checksum FILE=mydata.zip

# After decode on client
make checksum FILE=mydata_decoded.zip
```

The two SHA256 values should match.

---

## Security notes

- Base64 is **not encryption**. Anyone with the chunks can reconstruct the zip.
- For confidentiality, encrypt *before* encoding. Stock Python’s `zipfile` doesn’t provide modern AES encryption. If policy allows, pre‑encrypt data (outside this tool) before zipping/encoding.

---

## Troubleshooting

- **Decode error / Bad base64**: A character was likely missed during copy. Re‑copy the chunk(s) using `less -S` or `cat` and try again.
- **Merge says a chunk is missing**: Ensure `CHUNKS` matches exactly and all files are present (`*_1.txt ... *_N.txt`).
- **No `unzip` on client**: The Makefile’s `decode` target falls back to Python automatically.
- **Permissions**: After cloning on Unix, you may run `chmod +x scripts/*.sh`.

---

## Project layout

```
airgap-file-transfer/
├── README.md
├── LICENSE
├── Makefile
├── src/
│   ├── __init__.py
│   ├── zip_folder.py
│   ├── encode.py
│   ├── decode.py
│   ├── split_file.py
│   ├── merge_files.py
│   └── hash_file.py
├── scripts/
│   ├── server_encode.sh
│   ├── server_split.sh
│   ├── client_merge.sh
│   └── client_decode.sh
└── scripts/examples/
    ├── encode.sh
    ├── split.sh
    ├── merge_files.sh
    ├── decode.sh
    ├── decode_update.sh
    └── decode_merged.sh
```

---

## License

MIT — see [LICENSE](LICENSE)
