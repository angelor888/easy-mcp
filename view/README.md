# View Directory for MCP Filesystem Service

This directory is mapped to the `/app/projects` path inside the `mcp-filesystem` Docker container.

Any files or folders you place in this `view/` directory on your host machine will be accessible by the `mcp-filesystem` service. This allows the service to interact with your local project files in real-time.

For example, if you configure the Claude Desktop `filesystem` MCP server to point to a project within `/app/projects` (e.g., `/app/projects/my_project1`), it will correspond to `view/my_project1` on your host system.
