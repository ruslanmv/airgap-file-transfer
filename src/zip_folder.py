#!/usr/bin/env python3
import argparse
import os
import zipfile

def zip_directory(src_dir: str, zip_path: str) -> None:
    src_dir = os.path.abspath(src_dir)
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
        for root, _, files in os.walk(src_dir):
            for name in files:
                full = os.path.join(root, name)
                arcname = os.path.join(os.path.basename(src_dir), os.path.relpath(full, src_dir))
                zf.write(full, arcname)

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Zip a folder using only the Python standard library.")
    p.add_argument("folder", help="Folder to zip")
    p.add_argument("-o", "--output", help="Output zip path (default: <folder>.zip)")
    args = p.parse_args()

    out = args.output or (os.path.basename(os.path.normpath(args.folder)) + ".zip")
    zip_directory(args.folder, out)
    print(f"Zipped '{args.folder}' -> {out}")
