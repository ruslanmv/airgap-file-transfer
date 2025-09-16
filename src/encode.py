#!/usr/bin/env python3
import base64
import argparse

def encode_zip_to_txt(zip_file_path: str, output_file_path: str = None) -> str:
    try:
        with open(zip_file_path, 'rb') as f:
            zip_data = f.read()

        encoded_data = base64.b64encode(zip_data)
        encoded_string = encoded_data.decode('UTF-8')

        output_file_path = output_file_path or zip_file_path.replace(".zip", "_encoded.txt")
        with open(output_file_path, 'w') as outfile:
            outfile.write(encoded_string)

        print(f"Encoded data saved to: {output_file_path}")
        return output_file_path

    except FileNotFoundError:
        print(f"Error: Zip file not found at {zip_file_path}")
        raise
    except Exception as e:
        print(f"An error occurred: {e}")
        raise

if __name__ == "__main__":
    ap = argparse.ArgumentParser(description="Encode a .zip into base64 text.")
    ap.add_argument("zip_path", help="Path to .zip file")
    ap.add_argument("-o", "--output", help="Output .txt path (default: <zip>_encoded.txt)")
    args = ap.parse_args()
    encode_zip_to_txt(args.zip_path, args.output)
