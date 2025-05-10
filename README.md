# Dockerized MCP (Model Context Protocol) Services

This project streamlines deployment of Model Context Protocol (MCP) services using Docker and Docker Compose, enabling developers to integrate with clients like Claude Desktop. It provides clear instructions for macOS and Windows users.

[繁體中文 README](./README.zh-TW.md) | **English**

## Quick Start

Deploy MCP services with these steps:

1. **Install Prerequisites**:

   - [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Git (`git --version` to verify)
   - `uvx` (for Time/Fetch, verify with `uvx --version`)

2. **Clone Repository**:

   ```bash
   git clone https://github.com/NovaProtocol/easy-mcp.git
   cd easy-mcp
   ```

3. **Configure Environment**:

   ```bash
   cp .env.example .env
   ```

   - Edit `.env`, add Brave Search API key.

4. **Start Services**:

   - **macOS/Linux**:
     ```bash
     chmod +x start.sh
     ./start.sh
     ```
   - **Windows**: Run `start.bat`.

5. **Verify**:
   - Run `docker ps` to confirm containers.
   - Check client logs for connectivity.

## Included Services

1. **Dockerized Services** (managed by `docker-compose`):

   - **Filesystem**: Manages local files (mapped to `./view`).
   - **Brave Search**: Uses Brave Search API (requires API key).
   - **Puppeteer**: Headless Chrome automation.
   - **Memory**: In-memory storage.
   - **Everything**: General-purpose MCP server.

2. **Local `uvx` Services** (client-initiated via `uvx`):
   - **Time**: Time functions.
   - **Fetch**: URL content retrieval.

## Prerequisites

- **Docker Desktop**:

  - macOS/Windows: Install from [Docker](https://www.docker.com/products/docker-desktop/).
  - Windows: Enable WSL 2.
  - Verify: `docker --version`, `docker-compose --version`.

- **uvx**:

  - Verify: `uvx --version`.
  - Install per MCP or client documentation if needed.

- **Git**:
  - macOS: Pre-installed or via [Homebrew](https://brew.sh/) (`brew install git`).
  - Windows: Install from [Git](https://git-scm.com/download/win).

## Detailed Configuration

1. **Client Configuration (e.g., Claude Desktop)**:

   - Config paths:
     - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
     - Windows: `%APPDATA%\Claude\claude_desktop_config.json`
     - Linux: `~/.config/Claude/claude_desktop_config.json`
   - Backup config.
   - Use `claude_desktop_config.json.example` to update API keys and URLs.

2. **Disabling Services**:

   - Dockerized: Comment out service blocks in `docker-compose.yml`, rerun `docker-compose up --build -d`.
   - uvx: Remove entries from client config.

3. **Custom Services**:
   - See `custom_user_services/README.md` for adding Dockerized services.

## Stopping Services

- **Scripts**:
  - macOS/Linux: `./stop.sh`
  - Windows: `stop.bat`
- **Docker Compose**:
  ```bash
  docker-compose down
  ```

## Project Structure

- `.gitignore`: Ignored files.
- `claude_desktop_config.json.example`: Client config template.
- `custom_user_services/`: Custom services directory.
- `docker-compose.yml`: Docker service definitions.
- `LICENSE`: MIT License.
- `mcp_services/`: Node.js service code.
- `view/`: Mapped to `mcp-filesystem` container.
- `.env.example`, `.env`: Environment variables.
- `start.sh`, `start.bat`, `stop.sh`, `stop.bat`: Start/stop scripts.

## Troubleshooting

- **Docker**: Ensure Docker Desktop is running.
- **Logs**: Run `docker-compose logs <service_name>`.
- **Port Conflicts**: Adjust ports in `docker-compose.yml` and client config.
- **.env**: Verify file and API keys.
- **uvx**: Confirm installation and PATH.

## License

This project is licensed under the [MIT License](./LICENSE).
