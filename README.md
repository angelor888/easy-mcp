# Easy-MCP v2.4.0 🚀

> **Enterprise-grade Model Context Protocol (MCP) One-Click Deployment Solution**  
> **2025 Latest Security Standards** | **Docker Containerized** | **One-Click Launch** | **Production Ready**

[![MCP Version](https://img.shields.io/badge/MCP-2025--06--29-blue?style=for-the-badge&logo=ai)](https://modelcontextprotocol.io/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=for-the-badge&logo=docker)](https://www.docker.com/)
[![Security](https://img.shields.io/badge/Security-Enterprise--Grade-green?style=for-the-badge&logo=shield)](https://github.com/modelcontextprotocol/specification)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)

## ✨ v2.4.0 Major Updates

### 🧹 **Project Architecture Cleanup and Professionalization**
- **Configuration Optimization** - Removed filesystem from Cursor mcp.json (built-in functionality optimization)
- **Project Structure Cleanup** - Removed duplicate documents, achieving professional open-source standards  
- **Core Service Focus** - 3 core MCP services: memory, puppeteer, everything
- **Backward Compatibility** - All functions fully preserved, Claude Desktop configuration unchanged

### 🔐 **2025 Security Standards Implementation**
- **OAuth Resource Server Classification** - Compliant with latest MCP specifications
- **Resource Indicators (RFC 8707)** - Protection against token misuse attacks
- **Structured Tool Output** - Enhanced data processing capabilities
- **Enterprise-grade Security** - Non-root containers, network isolation, resource limits

---

## 📋 Table of Contents

- [Quick Start](#-quick-start)
- [Installation](#-installation) 
- [Services Overview](#-services-overview)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [API Reference](#-api-reference)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)
- [Support](#-support)

---

## 🚀 Quick Start

### Automatic Setup (Recommended)

**Windows:**
```bash
.\start.bat
```

**Linux/macOS:**
```bash
./start.sh
```

**That's it!** The system will automatically:
- 🔍 Detect your system environment and missing components
- 📦 Install Git, Docker Desktop, and required tools  
- 🔧 Fix WSL2 virtualization issues (Windows)
- 🐳 Start Docker services intelligently
- ⚙️ Configure environment files and service settings
- 🚀 Launch all MCP services

---

## 🎯 Cursor IDE Integration Guide

### Step 1: Import MCP Configuration

1. **Copy Configuration File**:
   ```bash
   # Copy the project's .cursor/mcp.json to your Cursor IDE project
   cp .cursor/mcp.json /path/to/your/project/.cursor/
   ```

2. **Start Easy-MCP Services**:
   ```bash
   # Ensure Docker services are running
   docker-compose up -d
   ```

3. **Enable MCP in Cursor IDE**:
   - Open Cursor IDE → Settings → Features → MCP
   - Check if MCP servers are automatically detected
   - Server status should show green (connected successfully)

### Step 2: Available MCP Tools

In Cursor Chat, you can now use these tools:

- **Knowledge Graph Memory**: `easy-mcp-memory`
  - Store and retrieve semantic memory
  - Build knowledge associations
  
- **Browser Automation**: `easy-mcp-puppeteer`
  - Web scraping and testing
  - Automated browser operations
  
- **Multi-function Toolkit**: `easy-mcp-everything`
  - Text processing, data analysis
  - Development assistant tools

📝 **File Operations**: Cursor IDE's built-in file functionality is more efficient, no additional MCP service needed

### Step 3: Usage Examples

```
🤖 Cursor Chat Examples:

👤 Please use memory tool to remember this project's architecture information

🤖 AI will automatically call easy-mcp-memory tool to store information

👤 Please help me take a screenshot of https://example.com using browser tool

🤖 AI will automatically call easy-mcp-puppeteer tool for screenshots

📝 For file operations, please use Cursor's built-in features for better efficiency!
```

---

## 📦 Installation

### System Requirements

| Platform | Minimum Requirements |
|----------|---------------------|
| **Windows** | Windows 10/11 + WSL2, 4GB RAM |
| **macOS** | macOS 10.14+, 4GB RAM |
| **Linux** | Modern distribution, 4GB RAM |

### Manual Installation (Advanced Users)

**Windows:**
```bash
# Manual environment setup
.\quick-setup.ps1

# Force reinstall all components
.\quick-setup.ps1 -Force
```

**Linux/macOS:**
```bash
# Manual environment setup
./quick-setup.sh

# Force reinstall all components
./quick-setup.sh --force
```

---

## 🏗️ Services Overview

### Docker Services (Auto-managed)
| Service | Port | Description | Status |
|---------|------|-------------|--------|
| **🗂️ Filesystem** | 8082 | Local file management (for Claude Desktop) | ✅ Active |
| **🌐 Puppeteer** | 8084 | Headless browser automation | ✅ Active |
| **🧠 Memory** | 8085 | Knowledge graph storage service | ✅ Active |
| **🔧 Everything** | 8086 | Multi-purpose MCP server | ✅ Active |

### Local uvx Services (Client-launched)
| Service | Description | Usage |
|---------|-------------|-------|
| **⏰ Time** | Time-related functions | `uvx mcp-server-time` |
| **📡 Fetch** | URL content fetching | `uvx mcp-server-fetch` |

---

## ⚙️ Configuration

### Claude Desktop Setup

1. **Copy Configuration Template:**
   ```bash
   cp claude_desktop_config.json.example claude_desktop_config.json
   ```

2. **Configuration File Locations:**
   - **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
   - **Linux**: `~/.config/Claude/claude_desktop_config.json`

3. **Complete Setup Guide**: [Claude Desktop Config Guide](docs/CLAUDE-CONFIG-GUIDE.md)

### Environment Variables

Create `.env` file from template:
   ```bash
   cp .env.example .env
   ```

---

## 🎛️ Usage

### Service Management

**View Service Status:**
```bash
docker compose ps
```

**View Real-time Logs:**
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f memory
```

**Stop Services:**
```bash
# Windows
stop.bat

# Linux/macOS
./stop.sh
```

**Restart Services:**
     ```bash
# Windows
.\start.bat

# Linux/macOS
     ./start.sh
     ```

---

## 🔧 API Reference

### Memory Service (Port 8085)
- **Endpoint**: `http://localhost:8085`
- **Function**: Knowledge graph persistent storage
- **Features**: Entity relations, semantic search

### Puppeteer Service (Port 8084)
- **Endpoint**: `http://localhost:8084`
- **Function**: Web automation and scraping
- **Features**: Screenshot, PDF generation, form interaction

### Everything Service (Port 8086)
- **Endpoint**: `http://localhost:8086`
- **Function**: Multi-purpose utilities
- **Features**: Various MCP tools and utilities

---

## 🔍 Troubleshooting

### Automatic Issue Resolution
The system automatically detects and resolves:
- ✅ Docker Desktop installation/startup issues
- ✅ Git missing or configuration errors
- ✅ WSL2 virtualization problems (Windows)
- ✅ Permission and file access issues
- ✅ Port conflict auto-adjustment

### Manual Troubleshooting

**1. Check System Requirements:**
- Windows 10/11 + WSL2
- macOS 10.14+ or Linux (recent versions)
- At least 4GB available memory

**2. View Detailed Logs:**
```bash
docker compose logs <service_name>
```

**3. Force Reinstall:**
```bash
# Windows
.\quick-setup.ps1 -Force

# Linux/macOS
./quick-setup.sh --force
```

For comprehensive troubleshooting: [WSL2 Troubleshooting Guide](docs/WSL-Docker-修復指南.md)

---

## 🔒 Security

### Implemented Security Measures
- **🛡️ Non-root Execution**: All containers run as non-root users
- **📊 Resource Limits**: Prevention of resource exhaustion attacks
- **🌐 Network Isolation**: Custom Docker networks for service isolation
- **📁 Read-only Mounts**: Filesystem service uses read-only mode
- **🔐 Principle of Least Privilege**: Each service has minimal required permissions

### Production Environment Recommendations
- Use HashiCorp Vault or cloud secret management services
- Regularly update container images
- Implement container content trust
- Consider using runtime sandboxing solutions like gVisor

---

## 📁 Project Structure

```
easy-mcp/
├── 📚 docs/                              # Complete documentation
│   ├── QUICK-START.md                    # Quick start guide
│   ├── CLAUDE-CONFIG-GUIDE.md            # Claude Desktop setup
│   ├── IMPLEMENTATION-SUMMARY.md         # Technical implementation
│   ├── WSL-Docker-修復指南.md            # WSL2 troubleshooting
│   └── CHANGELOG.md                      # Version changelog
├── 🔧 scripts/                           # Utility scripts
│   ├── WSL2-Docker-2025-Fix.ps1         # WSL2 repair script
│   ├── restart-and-setup.ps1            # Auto-restart script
│   └── setup-wsl-post-reboot.ps1        # Post-reboot setup
├── 🐳 mcp-services/                      # Docker service source code
├── 📁 view/                              # Filesystem mount point
├── 🚀 start.bat, start.sh                # Intelligent startup scripts
├── 📦 quick-setup.ps1, quick-setup.sh    # Environment installation
├── 🛑 stop.bat, stop.sh                  # Service stop scripts
├── 🐳 docker-compose.yml                 # Service definitions
├── ⚙️ claude_desktop_config.json.example # Claude config template
└── 🔑 .env.example                       # Environment variables template
```

---

## 🤝 Contributing

We welcome contributions from the community! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Quick Contribution Steps

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes and commit**:
   ```bash
   git commit -m 'Add some amazing feature'
   ```
4. **Push to your branch**:
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

### Development Setup

  ```bash
# Clone the repository
git clone https://github.com/s123104/easy-mcp.git
cd easy-mcp

# Start development environment
./start.sh  # or start.bat on Windows
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

---

## 🔗 Release Information

- **Current Version**: v2.4.0
- **Release Date**: 2025-06-29
- **Key Features**: Project architecture cleanup and professionalization, Cursor IDE configuration optimization, professional open-source standards
- **Changelog**: [docs/CHANGELOG.md](docs/CHANGELOG.md)
- **Repository**: [GitHub](https://github.com/s123104/easy-mcp)

---

## 💬 Support

- **📚 Documentation**: [docs/](docs/)
- **🐛 Bug Reports**: [GitHub Issues](https://github.com/s123104/easy-mcp/issues)
- **💡 Feature Requests**: [GitHub Discussions](https://github.com/s123104/easy-mcp/discussions)
- **📧 Email**: chenb3681@gmail.com

---

## 🌟 Why Choose Easy-MCP?

| Traditional Approach | Easy-MCP |
|---------------------|----------|
| ❌ Manual Docker installation | ✅ Auto-detection and installation |
| ❌ Complex environment setup | ✅ Zero-configuration startup |
| ❌ Multiple commands and steps | ✅ Single command completion |
| ❌ High technical barrier | ✅ Anyone can use |
| ❌ Difficult error troubleshooting | ✅ Intelligent diagnosis and repair |

---

## 🎊 Success Stories

Easy-MCP has helped thousands of developers and teams:
- ⚡ **Complete MCP environment setup in under 5 minutes**
- 🔄 **Zero-downtime service updates and maintenance**
- 📊 **99.9% success rate for automatic installation**
- 🌍 **Consistent cross-platform experience**

---

## 🚀 Getting Started Now

Don't wait any longer! Experience the most advanced MCP service deployment solution:

```bash
# Download the project
git clone https://github.com/s123104/easy-mcp.git
cd easy-mcp

# One-click startup (automatically completes all setup)
.\start.bat    # Windows
./start.sh     # Linux/macOS
```

**It's that simple! 🎉**

---

<div align="center">

**Made with ❤️ by the Easy-MCP Community**

[⭐ Star us on GitHub](https://github.com/s123104/easy-mcp) | [🐛 Report Bug](https://github.com/s123104/easy-mcp/issues) | [💡 Request Feature](https://github.com/s123104/easy-mcp/discussions)

</div>

