#!/usr/bin/env python3
import sys
import os

def merge_files(output_file, base_file_name, num_chunks):
    """
    Merges split files into a single text file.

    base_file_name should be the common prefix BEFORE '_<n>.txt',
    e.g. 'mydata_encoded.txt' to merge mydata_encoded.txt_1.txt, _2.txt, ...
    """
    try:
        with open(output_file, 'w') as merged_file:
            for i in range(1, num_chunks + 1):
                chunk_file_path = f"{base_file_name}_{i}.txt"
                if not os.path.exists(chunk_file_path):
                    print(f"Error: {chunk_file_path} does not exist.")
                    sys.exit(1)
                with open(chunk_file_path, 'r') as chunk_file:
                    merged_file.write(chunk_file.read())

        print(f"Files successfully merged into {output_file}.")

    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python src/merge_files.py <output_file> <base_file_name> <num_chunks>")
        sys.exit(1)

    output_file = sys.argv[1]
    base_file_name = sys.argv[2]
    num_chunks = int(sys.argv[3])

    merge_files(output_file, base_file_name, num_chunks)
