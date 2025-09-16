SHELL := /bin/bash

# -------- Default variables (override on the CLI) --------
FOLDER ?= payload_folder
ZIP ?= $(notdir $(FOLDER)).zip
CHUNKS ?= 3

# Derived names
ENCODED ?= $(ZIP:.zip=_encoded.txt)
MERGED ?= merged_$(ENCODED)
OUTDIR ?= out

.PHONY: help
help:
	@echo "Targets:"
	@echo "  zip                - Zip a folder with Python (FOLDER, ZIP)"
	@echo "  encode             - Encode ZIP -> TXT (ZIP -> ENCODED)"
	@echo "  split              - Split ENCODED into CHUNKS"
	@echo "  server-all         - Run zip -> encode -> split"
	@echo "  merge              - Merge chunks on client (ENCODED_BASE, CHUNKS, MERGED)"
	@echo "  decode             - Decode + unzip (TXT, OUTDIR)"
	@echo "  client-all         - merge -> decode"
	@echo "  checksum           - Print SHA256 of FILE"
	@echo "  view-chunk         - Interactively view a large chunk for copying (FILE)"

# -------- Server side --------

.PHONY: zip
zip:
	python3 src/zip_folder.py "$(FOLDER)" -o "$(ZIP)"

.PHONY: encode
encode:
	python3 src/encode.py "$(ZIP)"

.PHONY: split
split:
	python3 src/split_file.py "$(ENCODED)" "$(CHUNKS)"

.PHONY: server-all
server-all: zip encode split

# -------- Client side --------
# ENCODED_BASE is the base filename before _1.txt (e.g., mydata_encoded.txt)

.PHONY: merge
merge:
	@if [ -z "$$ENCODED_BASE" ] || [ -z "$(CHUNKS)" ]; then \
		echo "Usage: make merge ENCODED_BASE=<name_encoded.txt> CHUNKS=<N> [MERGED=<merged_name.txt>]"; \
		exit 1; \
	fi
	python3 src/merge_files.py "$(MERGED)" "$$ENCODED_BASE" "$(CHUNKS)"

.PHONY: decode
decode:
	@if [ -z "$$TXT" ]; then \
		echo "Usage: make decode TXT=<encoded_or_merged.txt> [OUTDIR=<out>]"; \
		exit 1; \
	fi
	bash scripts/client_decode.sh "$$TXT" "$(OUTDIR)"

.PHONY: client-all
client-all: merge
	@TXT="$(MERGED)" OUTDIR="$(OUTDIR)" $(MAKE) --no-print-directory decode

# -------- Utilities --------

.PHONY: checksum
checksum:
	@if [ -z "$$FILE" ]; then \
		echo "Usage: make checksum FILE=<path/to/file>"; \
		exit 1; \
	fi
	python3 src/hash_file.py "$$FILE"

.PHONY: view-chunk
view-chunk:
	@if [ -z "$$FILE" ]; then \
		echo "Usage: make view-chunk FILE=<path/to/chunk_file.txt>"; \
		exit 1; \
	fi
	@chmod +x scripts/chunk_view.sh
	@bash scripts/chunk_view.sh "$$FILE"