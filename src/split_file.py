#!/usr/bin/env python3
import sys

def split_file(file_path, num_chunks):
    """
    Splits a text file into a specified number of chunks.
    """
    try:
        with open(file_path, 'r') as f:
            file_content = f.read()

        chunk_size = len(file_content) // num_chunks
        remaining_chars = len(file_content) % num_chunks

        start = 0
        for i in range(num_chunks):
            end = start + chunk_size
            if i < remaining_chars:
                end += 1

            chunk_file_path = f"{file_path}_{i+1}.txt"
            with open(chunk_file_path, 'w') as chunk_file:
                chunk_file.write(file_content[start:end])

            start = end

        print(f"File '{file_path}' split into {num_chunks} chunks: {file_path}_1.txt .. _{num_chunks}.txt")

    except FileNotFoundError:
        print(f"Error: File not found at {file_path}")
        sys.exit(1)
    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python src/split_file.py <file_path> <num_chunks>")
        sys.exit(1)
    file_path = sys.argv[1]
    num_chunks = int(sys.argv[2])
    split_file(file_path, num_chunks)
