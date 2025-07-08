# Secrets Directory

This directory contains secret keys and credentials for MCP services.

## Setup Instructions

1. Copy the example files to create your actual secret files:
   ```bash
   cp mcp_secret.txt.example mcp_secret.txt
   cp filesystem_key.txt.example filesystem_key.txt
   ```

2. Edit each file and replace the placeholder with your actual secret keys.

3. Generate secure keys using:
   ```bash
   openssl rand -hex 32
   ```

## Security Notes

- Never commit actual secret files to git
- The `.gitignore` file is configured to exclude all `.txt` files in this directory
- Only `.example` files should be committed to the repository
- Keep your secrets secure and don't share them