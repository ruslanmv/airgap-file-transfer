#!/usr/bin/env python3
import base64
import argparse

def decode_txt_to_zip(txt_file_path: str, output_zip_path: str = None) -> str:
    """
    Decodes a base64 encoded string from a .txt file and saves it as a zip file.
    """
    try:
        with open(txt_file_path, 'r') as f:
            encoded_string = f.read()

        encoded_data = encoded_string.encode('UTF-8')
        decoded_data = base64.b64decode(encoded_data)

        output_file_path = output_zip_path or txt_file_path.replace("_encoded.txt", "_decoded.zip")
        with open(output_file_path, 'wb') as outfile:
            outfile.write(decoded_data)

        print(f"Decoded zip file saved to: {output_file_path}")
        return output_file_path

    except FileNotFoundError:
        print(f"Error: Encoded .txt file not found at {txt_file_path}")
        raise
    except Exception as e:
        print(f"An error occurred: {e}")
        raise

if __name__ == "__main__":
    ap = argparse.ArgumentParser(description="Decode base64 text back to .zip.")
    ap.add_argument("txt_path", help="Path to *_encoded.txt (or merged file containing '_encoded.txt' in its name)")
    ap.add_argument("-o", "--output", help="Output .zip path (default: <txt> with _encoded.txt -> _decoded.zip)")
    args = ap.parse_args()
    decode_txt_to_zip(args.txt_path, args.output)
