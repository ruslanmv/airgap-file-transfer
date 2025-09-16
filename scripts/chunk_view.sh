#!/bin/bash

# --- CONFIGURATION ---
FILENAME="$1"
CHUNK_SIZE=250000

# --- IGNORE CTRL+C ---
trap '' SIGINT

# --- VALIDATION ---
if [ -z "$FILENAME" ]; then
    echo "❗️ Usage: $0 <filename>"
    exit 1
fi
if [ ! -f "$FILENAME" ]; then
    echo "❌ Error: File '$FILENAME' not found."
    exit 1
fi

# --- MAIN LOGIC ---
TOTAL_SIZE=$(stat -c%s "$FILENAME")
OFFSET=0
CHUNK_NUM=1

echo "--- Displaying '$FILENAME' in chunks of up to ${CHUNK_SIZE} bytes ---" >&2
echo "--- Pressing Ctrl+C is disabled. Type 'q' and Enter to quit. ---" >&2

while [ "$OFFSET" -lt "$TOTAL_SIZE" ]; do
    echo "--- 📋 Chunk #$CHUNK_NUM --- (Press Enter for next, or 'q' to quit) ---" >&2

    # Explicitly calculate bytes to read for this chunk
    remaining_bytes=$((TOTAL_SIZE - OFFSET))
    bytes_to_read=$CHUNK_SIZE

    if [ "$remaining_bytes" -lt "$CHUNK_SIZE" ]; then
        bytes_to_read=$remaining_bytes
    fi

    # Use dd to extract and print the exact number of bytes calculated
    dd if="$FILENAME" bs=1 count=$bytes_to_read skip=$OFFSET status=none
    
    # --- FIX: Add a newline to separate data from the prompt ---
    echo
    # --- End of Fix ---

    # Update the offset for the next loop
    OFFSET=$((OFFSET + bytes_to_read))

    # Pause if there is more data left to read
    if [ "$OFFSET" -lt "$TOTAL_SIZE" ]; then
        read -p "--- End of Chunk #$CHUNK_NUM. Press Enter to continue... ---" user_input
        
        if [[ "$user_input" == "q" || "$user_input" == "Q" ]]; then
            echo "🛑 User requested exit." >&2
            exit 0
        fi
        
        # Add an empty line for spacing between chunks
        echo
    fi
    CHUNK_NUM=$((CHUNK_NUM + 1))
done

echo "✅ All done. Reached end of file." >&2