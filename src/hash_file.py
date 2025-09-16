#!/usr/bin/env python3
import hashlib
import sys

def sha256sum(path: str) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python src/hash_file.py <file>")
        sys.exit(1)
    path = sys.argv[1]
    print(sha256sum(path))
