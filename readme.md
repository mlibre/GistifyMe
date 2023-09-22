# GistifyMe Backup Script

**GistifyMe** Backup Script is a `Bash` script that allows you to easily back up files and folders, compress them using `xz`, and upload the backup to a `GitHub Gist`. This is useful for creating quick and versioned backups of your important data.

## Prerequisites

Before using this script, make sure you have the following installed:

- [GitHub Token](https://github.com/settings/tokens/): You'll need to to upload backups to Gists
- [xz-utils](https://tukaani.org/xz/): This script uses `xz` for compression, so ensure it's available on your system

## Usage

1. Clone this repository or download the script directly.

   ```bash
   git clone https://github.com/mlibre/GistifyMe
   ```

2. Make the script executable by running the following command:

   ```bash
   chmod +x gistifyme.bash
   ```

3. Run the script with the following command:

   ```bash
   ./gistifyme.bash <GitHub Token> [file1 file2 ...] [folder1 folder2 ...]
   ```

   Replace `<GitHub Token>` with your GitHub Personal Access Token, which is required to create Gists. You can generate a token in your [GitHub account settings](https://github.com/settings/tokens).

   Provide a list of files and folders you want to back up as arguments. The script will create a timestamped archive of the specified sources and upload it to a public GitHub Gist.

   Example:

   ```bash
   ./gistifyme.bash YOUR_GITHUB_TOKEN file1.txt folder1 file2.txt
   ```

4. Once the script finishes, it will display the `URL` of the created Gist, where you can access and share your backup.

## Tips

- Customize the backup directory path in the script to suit your preferences
- You can adjust the compression level in the script (currently set to the maximum, `-9`) if needed
- Ensure your GitHub Token has the necessary permissions to create Gists

## Reading a Gist Backup

If you have previously created a backup using the GistifyMe Backup Script and want to retrieve and extract it, you can use the `readgistify.bash` script. Here's how to use it:

1. Make sure you have the `readgistify.bash` script in the same directory as your Gistif`yMe script, or you can download it from the [GitHub repository](https://github.com/mlibre/GistifyMe).

2. Run the script with the following command:

   ```bash
   ./readgistify.bash <Gist URL> [output directory]
   # Example:
   ./readgistify.bash "https://gist.github.com/mlibre/6bf478862e6c51164c74b52a4c058bf3"
   ```

## License

This script is released under the public dogistifyme using the [Unlicense](https://unlicense.org/)

Feel free to fork this repository, make improvements, and use it for your backup needs
