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
   git clone https://github.com/s123104/easy-mcp.git
   cd easy-mcp
   ```

3. **Configure Environment**:

   ```bash
   cp .env.example .env
   ```

   - Edit `.env` to set your environment variables. This includes setting `BRAVE_API_KEY=your_api_key_here` for the Brave Search service, along with any other necessary variables.

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

   - **Filesystem**: Manages local files (mapped to `./view` in read-only mode).
   - **Brave Search**: Uses Brave Search API (requires API key, managed via Docker Secrets from `brave_api_key.txt`).
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
 - `.env.example`, `.env`: Environment variables. The `BRAVE_API_KEY` for the Brave Search service is configured in the `.env` file (copied from `.env.example`).
- `start.sh`, `start.bat`, `stop.sh`, `stop.bat`: Start/stop scripts.

## Troubleshooting

- **Docker**: Ensure Docker Desktop is running.
- **Logs**: Run `docker-compose logs <service_name>`.
- **Port Conflicts**: Adjust ports in `docker-compose.yml` and client config.
- **.env**: Verify file and API keys.
- **uvx**: Confirm installation and PATH.

## License

This project is licensed under the [MIT License](./LICENSE).

## Security Considerations

This project has been configured with several security best practices in mind. Understanding and maintaining these practices is crucial for a secure deployment.

### Docker Compose Best Practices Implemented

The `docker-compose.yml` file incorporates the following security measures:

-   **Non-Root Users**: All services are configured to run as a non-root user (`1000:1000`) to reduce potential damage if a container is compromised.
-   **Resource Limits**: Each service has `mem_limit` and `cpus` constraints defined to prevent resource exhaustion and denial-of-service scenarios.
-   **Network Isolation**: Services are placed on a custom Docker network (`mcp-net`), which can be further configured to restrict inter-service communication if needed.
 -   **Secrets Management (Brave Search)**: The Brave Search API key is configured via the `BRAVE_API_KEY` environment variable, which should be set in the `.env` file. For production, consider more robust secrets management like HashiCorp Vault or cloud provider solutions.
-   **Read-Only Volumes**: The `mcp-filesystem` service mounts its `./view` directory as read-only (`ro`) to prevent unauthorized modifications to these files from within the container.

### Managing Secrets

The Brave Search API key is now defined in the `.env` file (copied from `.env.example`) using the `BRAVE_API_KEY` variable. This key is then passed as an environment variable to the `mcp-brave-search` service.
For production environments, it is highly recommended to use more robust secrets management tools like HashiCorp Vault or cloud provider-specific solutions instead of relying solely on `.env` files.

While Docker Secrets is a valid approach for managing sensitive data (and you can learn more about it [here](https://docs.docker.com/engine/swarm/secrets/)), this project has been simplified to use environment variables for the Brave Search API key for easier setup.

### Brave Search Service Security (`./mcp-services/src/brave-search/`)

The Brave Search service, located at `mcp-services/src/brave-search/`, interacts with external APIs and processes external data. It's important to be aware of potential risks:

-   **Remote Code Execution (RCE) / Prompt Injection**: Depending on how the service processes inputs and constructs queries to the Brave Search API, there could be risks of injection attacks if not handled carefully. Regularly review the service's code for secure input validation and output encoding.
-   **Static Analysis**: It is highly recommended to use static analysis security testing (SAST) tools to scan the codebase for potential vulnerabilities. Consider integrating tools like:
    -   **Snyk**: [https://snyk.io/](https://snyk.io/) - Can help find and fix vulnerabilities in your code and dependencies.
    -   **ESLint**: [https://eslint.org/](https://eslint.org/) - While primarily a linter, with appropriate plugins (e.g., `eslint-plugin-security`), it can help identify some security anti-patterns in JavaScript/TypeScript code.

### Principle of Least Privilege

The configurations aim to follow the principle of least privilege:
-   Running services as non-root users.
-   Mounting volumes as read-only where possible.
This limits the potential impact of a security breach.

### Image Security

Consider implementing Docker Content Trust for signing and verifying images, ensuring that you are running legitimate and untampered container images.
-   [Docker Content Trust Documentation](https://docs.docker.com/engine/security/trust/)

### Runtime Sandboxing

For an additional layer of security, especially for services that process untrusted input, explore runtime sandboxing solutions like gVisor. gVisor provides an additional isolation boundary between the containerized application and the host kernel.
-   [gVisor Introduction](https://gvisor.dev/)

### Further Learning & MCP Specifics

-   For general MCP security best practices, please refer to the official Anthropic MCP documentation (if available publicly, otherwise adapt this line). A placeholder link: [https://docs.anthropic.com/mcp](https://docs.anthropic.com/mcp) (Please replace with the actual link if it differs or is internal).

## Versioning & Changelog

The current version is stored in [`version.txt`](./version.txt). All notable changes are tracked in [`CHANGELOG.md`](./docs/CHANGELOG.md).

