#!/bin/bash

# Function to display usage instructions
usage() {
	echo "Usage: $0 -g <GitHub Token> -f file1 [-f folder1 ...] [-d <output_dir>]"
	echo "Usage: $0 -r <Gist URL> [-d <output_dir>]"
	exit 1
}

if ! command -v jq &>/dev/null; then
	echo "jq is not installed. Please install it before running this script."
	exit 1
fi

# Initialize variables
github_token=""
output_dir="."
files_to_backup=()
gist_url=""

# Process command-line arguments
while getopts ":g:f:d:r:" opt; do
	case $opt in
	g)
		github_token="$OPTARG"
		;;
	f)
		files_to_backup+=("$OPTARG")
		;;
	d)
		output_dir="$OPTARG"
		;;
	r)
		gist_url="$OPTARG"
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

if [ -n "$gist_url" ]; then
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
else
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
	mkdir -p "$output_dir"

	timestamp=$(date +'%Y-%m-%dT%H-%M-%S')
	gist_filename="backup_$timestamp.tar.xz"
	backup_file="$output_dir/backup_$timestamp.tar.xz"

	# Create a tar archive and compress it with xz
	tar -cv "${files_to_backup[@]}" | xz -9 -c - >"$backup_file"

	tarxzfile=$(base64 -w 0 <"$backup_file")

	# Create a new Gist with the backup
	gist_response=$(curl -X POST -H "Authorization: token $github_token" \
		-d '{"public":true,"files":{"'$gist_filename'":{"content":"'$tarxzfile'"}}}' \
		"https://api.github.com/gists")

	# Extract the Gist URL from the response
	gist_url=$(echo "$gist_response" | jq -r '.html_url')

	echo "Backup uploaded to GitHub Gist successfully."
	echo "Gist URL: $gist_url"
fi
