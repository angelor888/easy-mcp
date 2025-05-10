Dockerized MCP (Model Context Protocol) Services
This project streamlines deployment of Model Context Protocol (MCP) services using Docker and Docker Compose, enabling developers to integrate with clients like Claude Desktop. It provides clear instructions for macOS and Windows users.
繁體中文 README | English
Quick Start
Deploy MCP services with these steps:

Install Prerequisites:

Docker Desktop
Git (git --version to verify)
uvx (for Time/Fetch, verify with uvx --version)

Clone Repository:
git clone https://github.com/NovaProtocol/easy-mcp.git
cd easy-mcp

Configure Environment:
cp .env.example .env

Edit .env, add Brave Search API key.

Start Services:

macOS/Linux:chmod +x start.sh
./start.sh

Windows: Run start.bat.

Verify:

Run docker ps to confirm containers.
Check client logs for connectivity.

Included Services

Dockerized Services (managed by docker-compose):

Filesystem: Manages local files (mapped to ./view).
Brave Search: Uses Brave Search API (requires API key).
Puppeteer: Headless Chrome automation.
Memory: In-memory storage.
Everything: General-purpose MCP server.

Local uvx Services (client-initiated via uvx):

Time: Time functions.
Fetch: URL content retrieval.

Prerequisites

Docker Desktop:

macOS/Windows: Install from Docker.
Windows: Enable WSL 2.
Verify: docker --version, docker-compose --version.

uvx:

Verify: uvx --version.
Install per MCP or client documentation if needed.

Git:

macOS: Pre-installed or via Homebrew (brew install git).
Windows: Install from Git.

Detailed Configuration

Client Configuration (e.g., Claude Desktop):

Config paths:
macOS: ~/Library/Application Support/Claude/claude_desktop_config.json
Windows: %APPDATA%\Claude\claude_desktop_config.json
Linux: ~/.config/Claude/claude_desktop_config.json

Backup config.
Use claude_desktop_config.json.example to update API keys and URLs.

Disabling Services:

Dockerized: Comment out service blocks in docker-compose.yml, rerun docker-compose up --build -d.
uvx: Remove entries from client config.

Custom Services:

See custom_user_services/README.md for adding Dockerized services.

Stopping Services

Scripts:
macOS/Linux: ./stop.sh
Windows: stop.bat

Docker Compose:docker-compose down

Project Structure

.gitignore: Ignored files.
claude_desktop_config.json.example: Client config template.
custom_user_services/: Custom services directory.
docker-compose.yml: Docker service definitions.
LICENSE: MIT License.
mcp_services/: Node.js service code.
view/: Mapped to mcp-filesystem container.
.env.example, .env: Environment variables.
start.sh, start.bat, stop.sh, stop.bat: Start/stop scripts.

Troubleshooting

Docker: Ensure Docker Desktop is running.
Logs: Run docker-compose logs <service_name>.
Port Conflicts: Adjust ports in docker-compose.yml and client config.
.env: Verify file and API keys.
uvx: Confirm installation and PATH.

License
This project is licensed under the MIT License.
