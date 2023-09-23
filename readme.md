# GistifyMe Backup and Restore Script

**GistifyMe** is a versatile `Bash` script that enables you to back up and restore files and folders, compress them using `xz`, and upload the backup to a `GitHub Gist`. Whether you want to create backups or retrieve and extract previous ones, GistifyMe has you covered.

## Prerequisites

Before using this script, make sure you have the following installed:

- [GitHub Token](https://github.com/settings/tokens/): You'll need it for uploading backups to Gists.
- [xz-utils](https://tukaani.org/xz/): This script utilizes `xz` for compression, so ensure it's available on your system.

## Backup Usage

1. Clone this repository or download the script directly

   ```bash
   git clone https://github.com/mlibre/GistifyMe
   cd GistifyMe
   ```

2. Make the script executable by running the following command

   ```bash
   chmod +x gistifyme.bash
   ```

3. Run the script with the following command

   ```bash
   ./gistifyme.bash -g <GitHub Token> -f file1 [-f folder1 ...] [-d <output_dir>]
   ```

   Replace `<GitHub Token>` with your GitHub Personal Access Token, which is required to create Gists. You can generate a token in your [GitHub account settings](https://github.com/settings/tokens).

   Provide a list of files and folders you want to back up as arguments. The script will create a timestamped archive of the specified sources and upload it to a public GitHub Gist.

   Example:

   ```bash
   ./gistifyme.bash -g "YOUR_GITHUB_TOKEN" -f file1.txt -f folder1 -d ./backup/
   ```

4. Once the script finishes, it will display the `URL` of the created Gist, where you can access and share your backup.

## Restore Usage

To retrieve and extract a Gist backup, you can use the same script. Here's how:

1. Run the script with the following command, providing the Gist URL and an optional output directory:

   ```bash
   ./gistifyme.bash -r <Gist URL> [-d <output_dir>]
   # Example:
   ./gistifyme.bash -r "https://gist.github.com/mlibre/6bf478862e6c51164c74b52a4c058bf3"
   ```

   If you don't specify an output directory, the script will extract the backup in the current directory.

## Tips

- Customize the backup directory path in the script to suit your preferences
- You can adjust the compression level in the script (currently set to the maximum, `-9`) if needed
- Ensure your GitHub Token has the necessary permissions to create and access Gists

## License

This script is released under the public domain using the [Unlicense](https://unlicense.org/).

Feel free to fork this repository, make improvements, and use it for your backup and restore needs.
