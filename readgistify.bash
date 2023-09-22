#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 <Gist URL> <output directory>"
    exit 1
}

# Check if there are two arguments (Gist URL and output directory)
if [ $# -ne 2 ]; then
    usage
fi

# Gist URL
gist_url="$1"

# Output directory
output_dir="$2"

# Ensure the output directory exists
mkdir -p "$output_dir"

# Extract the Gist ID from the URL
gist_id=$(echo "$gist_url" | awk -F'/' '{print $(NF)}')
username=$(echo "$gist_url" | awk -F'/' '{print $(NF-1)}')

# Construct the raw Gist URL
raw_gist_url="https://gist.githubusercontent.com/$username/$gist_id/raw/"
echo $raw_gist_url

# Use curl to fetch the raw Gist content and save it to a file
curl -L "$raw_gist_url" | base64 -d > "$output_dir/backup.tar.xz"

echo "Gist content has been successfully fetched to $output_dir/backup.tar.xz"
