#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 <GitHub Token> [file1 file2 ...] [folder1 folder2 ...]"
    exit 1
}

# Check if there are at least two arguments (GitHub Token and backup sources)
if [ $# -lt 2 ]; then
    usage
fi

# GitHub Personal Access Token
github_token="$1"
shift  # Remove the GitHub Token from the argument list

# Destination folder for backups
backup_dir="./gistifyMe-backups"

# Timestamp for the backup filename
timestamp=$(date +'%Y-%m-%dT%H-%M-%S')

# Archive filename
backup_file="$backup_dir/backup_$timestamp.tar.xz"

# Create an array to store backup sources
backup_sources=()

# Loop through the remaining arguments and add them to the backup sources array
for arg in "$@"; do
    if [ -e "$arg" ]; then
        backup_sources+=("$arg")
    else
        echo "Warning: '$arg' does not exist and will be skipped."
    fi
done

# Check if there are valid backup sources
if [ ${#backup_sources[@]} -eq 0 ]; then
    echo "No valid backup sources provided."
    usage
fi

# Create the backup directory if it doesn't exist
mkdir -p "$backup_dir"

# Create a tar archive and compress it with xz
tar -cv "${backup_sources[@]}" | xz -9 -c - > "$backup_file"

# Upload the backup to a GitHub Gist using curl
gist_description="Backup created on $timestamp by gistifyMe"
gist_filename="backup_$timestamp.tar.xz"

tarxzfile=$(base64 -w 0 < "$backup_file")
echo $tarxzfile

# Create a new Gist with the backup
gist_response=$(curl -X POST -H "Authorization: token $github_token" \
    -d '{"public":true,"files":{"'$gist_filename'":{"content":"'$tarxzfile'"}}}' \
    "https://api.github.com/gists")

# Extract the Gist URL from the response
gist_url=$(echo "$gist_response" | jq -r '.html_url')

echo "Backup uploaded to GitHub Gist successfully."
echo "Gist URL: $gist_url"
