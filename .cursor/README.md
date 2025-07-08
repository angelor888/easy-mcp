# Cursor IDE Configuration

This directory contains configuration files for Cursor IDE integration with Easy-MCP.

## Setup Instructions

1. Copy the example configuration file:
   ```bash
   cp mcp.json.example mcp.json
   ```

2. Ensure Docker services are running:
   ```bash
   docker compose up -d
   ```

3. Import the configuration in Cursor IDE:
   - Place this `.cursor` directory in your project root
   - Restart Cursor IDE
   - Check Settings → Features → MCP to verify servers are detected

## Available MCP Servers

- **easy-mcp-memory**: Knowledge graph and persistent storage
- **easy-mcp-puppeteer**: Web automation and browser control
- **easy-mcp-everything**: Multi-purpose utilities

## Note

The `mcp.json` file is user-specific and should not be committed to version control. Only the example file and documentation should be in the repository.