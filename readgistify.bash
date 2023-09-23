#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 -l <Gist URL>  [-d output_dir]"
    exit 1
}

# Initialize variables
gist_url=""
output_dir="."

# Parse command line options
while getopts ":l:d:" opt; do
    case $opt in
    l)
        gist_url="$OPTARG"
        ;;
    d)
        output_dir="$OPTARG"
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        usage
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        usage
        ;;
    esac
done

# Check if a Gist URL was provided
if [ -z "$gist_url" ]; then
    echo "Gist URL is required."
    usage
fi

# Ensure the output directory exists
mkdir -p "$output_dir"

# Extract the Gist ID from the URL
gist_id=$(echo "$gist_url" | awk -F'/' '{print $(NF)}')
username=$(echo "$gist_url" | awk -F'/' '{print $(NF-1)}')

# Construct the raw Gist URL
raw_gist_url="https://gist.githubusercontent.com/$username/$gist_id/raw/"

# Use curl to fetch only the headers and capture the response code
http_status_code=$(curl -s -o /dev/null -w "%{http_code}" "$raw_gist_url")

# Check if the HTTP status code is 200 (OK)
if [ "$http_status_code" -eq 200 ]; then
    # If the status code is 200, proceed to fetch and save the content
    echo "HTTP status code: $http_status_code"
    curl -L "$raw_gist_url" | base64 -d >"$output_dir/backup.tar.xz"
    echo "Gist content has been successfully fetched to $output_dir/backup.tar.xz"
else
    # If the status code is not 200, display an error message
    echo "HTTP status code: $http_status_code"
    echo "Failed to fetch Gist content. Check the Gist URL and try again."
fi
