# Easy-MCP Setup & Recovery SOP  
_Last updated: 2025-07-07_

---

## Purpose  
Step-by-step playbook to spin up, repair, or clone the local MCP (Model Context Protocol) Docker stack and wire it to Claude Desktop & Claude Code.

## Services & Ports  

| Service      | Container           | Host → Container |
|--------------|---------------------|------------------|
| filesystem   | mcp-filesystem      | **8082:8082**    |
| puppeteer    | mcp-puppeteer       | **8084:8084**    |
| memory       | mcp-memory          | **8085:8085**    |
| everything   | mcp-everything      | **8086:8086**    |

---

## First-time setup (fresh clone)

```bash
git clone <repo> ~/easy-mcp
cd ~/easy-mcp
docker compose config            # no YAML errors
docker compose up -d
docker compose ps                # ports table must match above
cp claude_desktop_config.json "~/Library/Application Support/Claude/"
claude                           # launch CLI
> /init                          # creates CLAUDE.md
