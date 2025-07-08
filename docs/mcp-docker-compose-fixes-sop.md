# MCP Docker Compose Common Issues & Fixes SOP
_Last updated: 2025-07-07_

---

## Purpose
This SOP provides quick solutions for common Docker Compose and MCP integration issues encountered during Easy-MCP setup. Use this as a first-line troubleshooting guide.

---

## Issue 1: YAML Parse Errors

### Symptoms
```
yaml: could not find expected ':' (line X)
```

### Root Cause
Stray characters at the beginning of the file or malformed YAML syntax.

### Fix
1. Open `docker-compose.yml`
2. Check line 1 - must start with `#` or valid YAML
3. Remove any stray characters (letters, spaces, special chars)
4. Validate with: `docker compose config`

### Prevention
- Always use a YAML linter before committing
- Never edit docker-compose.yml in non-code editors

---

## Issue 2: Duplicate Ports Key

### Symptoms
```
yaml: mapping key "ports" already defined at line X
```

### Root Cause
Service has multiple `ports:` blocks defined.

### Fix
1. Locate the service with duplicate `ports:` entries
2. Keep only ONE `ports:` block per service
3. Merge all port mappings under single block:
```yaml
ports:
  - "8082:8082"
  # NOT two separate ports: blocks!
```

### Prevention
- Use search to find all `ports:` occurrences
- Maintain one ports block per service

---

## Issue 3: Port Mapping Incorrect/Missing

### Symptoms
- `docker compose ps` shows wrong ports or missing mappings
- Services accessible on wrong ports
- Connection refused errors

### Root Cause
Incorrect indentation or wrong port numbers.

### Fix
Ensure exact indentation and mappings:
```yaml
services:
  mcp-filesystem:
    # ... other config ...
    ports:      # 4 spaces before ports:
      - "8082:8082"  # 6 spaces before dash
```

### Correct Mappings
| Service | Port Mapping |
|---------|--------------|
| mcp-filesystem | 8082:8082 |
| mcp-puppeteer | 8084:8084 |
| mcp-memory | 8085:8085 |
| mcp-everything | 8086:8086 |

---

## Issue 4: MCP Connection Errors in Claude

### Symptoms
- Services show as disconnected in Claude Desktop
- `/status` shows no MCP servers
- Connection timeouts

### Root Cause
1. Containers not running
2. Config file not in correct location
3. Claude Desktop needs restart

### Fix
```bash
# 1. Verify containers are running
docker compose ps

# 2. Copy config to Claude directory
cp claude_desktop_config.json ~/Library/Application\ Support/Claude/

# 3. Restart Claude Desktop completely
# Quit Claude Desktop (Cmd+Q)
# Relaunch Claude Desktop
```

---

## Issue 5: Curl Connection Reset

### Symptoms
```
curl: (56) Recv failure: Connection reset by peer
```

### Root Cause
MCP services use MCP protocol over stdio, NOT HTTP.

### Fix
This is expected behavior! Don't use curl to test MCP services.

### Correct Testing
- Use `/status` or `mcp list` within Claude Desktop chat
- Check container health with `docker compose ps`
- View logs with `docker compose logs [service-name]`

---

## Issue 6: Git Commit Failures

### Symptoms
```
Author identity unknown
fatal: unable to auto-detect email address
```

### Fix
```bash
# Set local (project-specific) identity
git config user.email "your-email@example.com"
git config user.name "Your Name"

# Or set global identity
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"
git config --global github.user "your-github-username"
```

---

## Quick Diagnostic Commands

```bash
# 1. Validate YAML syntax
docker compose config

# 2. Check container status
docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"

# 3. View service logs
docker compose logs -f [service-name]

# 4. Full reset
docker compose down
docker compose up -d

# 5. Verify port listeners
lsof -i :8082,8084,8085,8086
```

---

## Complete Recovery Sequence

If nothing else works, follow this sequence:

```bash
# 1. Stop everything
docker compose down -v

# 2. Clean Docker system
docker system prune -f

# 3. Validate configuration
docker compose config

# 4. Start fresh
docker compose up -d

# 5. Verify all services
docker compose ps

# 6. Copy Claude config
cp claude_desktop_config.json ~/Library/Application\ Support/Claude/

# 7. Restart Claude Desktop
# Quit and relaunch Claude Desktop

# 8. Test in Claude
# Type: /status or mcp list
```

---

## Validation Checklist

- [ ] `docker compose config` - No errors
- [ ] `docker compose ps` - All containers "Up"
- [ ] Port mappings match table above
- [ ] Config file copied to Claude directory
- [ ] Claude Desktop restarted
- [ ] `/status` shows all 4 services with ✓

---

## Pro Tips

1. **Use the alias**: After setup, use `claude-mcp` to auto-navigate and launch
2. **Check logs first**: `docker compose logs` often reveals the real issue
3. **Mind the indentation**: YAML is space-sensitive, not tab-sensitive
4. **One change at a time**: Fix one error, test, then move to next
5. **Keep backups**: `cp docker-compose.yml docker-compose.yml.backup`

---

_End of SOP_