#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 -g <GitHub Token> [-f file1] [-f folder1 ...] [-d <backup_dir>]"
    exit 1
}

# Initialize variables with default values
github_token=""
backup_dir="."
files_to_backup=()

timestamp=$(date +'%Y-%m-%dT%H-%M-%S')
gist_description="Backup created on $timestamp by gistifyMe"
gist_filename="backup_$timestamp.tar.xz"

# Process command-line arguments
while getopts ":g:f:d:" opt; do
    case $opt in
        g)
            github_token="$OPTARG"
            ;;
        f)
            files_to_backup+=("$OPTARG")
            ;;
        d)
            backup_dir="$OPTARG"
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

backup_file="$backup_dir/backup_$timestamp.tar.xz"

# Check if GITHUB_TOKEN environment variable is set
if [ -z "$github_token" ]; then
    if [ -n "$GITHUB_TOKEN" ]; then
        github_token="$GITHUB_TOKEN"
    else
        echo "GitHub Token not provided. Set it as an environment variable or use the -g option."
        usage
    fi
fi

# Check if there are valid backup sources
if [ ${#files_to_backup[@]} -eq 0 ]; then
    echo "No valid backup sources provided."
    usage
fi

# Create the backup directory if it doesn't exist
mkdir -p "$backup_dir"

# Create a tar archive and compress it with xz
tar -cv "${files_to_backup[@]}" | xz -9 -c - > "$backup_file"

# Upload the backup to a GitHub Gist using curl

tarxzfile=$(base64 -w 0 < "$backup_file")

# Create a new Gist with the backup
gist_response=$(curl -X POST -H "Authorization: token $github_token" \
    -d '{"public":true,"files":{"'$gist_filename'":{"content":"'$tarxzfile'"}}}' \
    "https://api.github.com/gists")

# Extract the Gist URL from the response
gist_url=$(echo "$gist_response" | jq -r '.html_url')

echo "Backup uploaded to GitHub Gist successfully."
echo "Gist URL: $gist_url"
