#!/usr/bin/env bash

# Output file
OUTPUT="context-bundle.txt"

# Clear existing output file if it exists
> "$OUTPUT"

echo "### Directory Structure ###" >> "$OUTPUT"
echo '```text' >> "$OUTPUT"
# Use tree to map the directory, ignoring git internals and the output file itself
tree -a -I '.git|context-bundle.txt' >> "$OUTPUT"
echo '```' >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "### File Contents ###" >> "$OUTPUT"

# Loop through all files in the directory (excluding .git and the bundle file)
find . -type f -not -path '*/\.git/*' -not -name "$OUTPUT" | sort | while read -r file; do
    # Strip the leading './' for cleaner display
    clean_name="${file#./}"
    
    echo "==== File: $clean_name ====" >> "$OUTPUT"
    
    # Optional: You can add specific language tags to the markdown blocks based on file extension
    ext="${clean_name##*.}"
    if [ "$ext" = "nix" ]; then
        echo '```nix' >> "$OUTPUT"
    elif [ "$ext" = "md" ]; then
        echo '```markdown' >> "$OUTPUT"
    elif [ "$ext" = "sh" ]; then
        echo '```bash' >> "$OUTPUT"
    else
        echo '```' >> "$OUTPUT"
    fi
    
    cat "$file" >> "$OUTPUT"
    echo '```' >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
done

echo "Context successfully bundled into $OUTPUT"
