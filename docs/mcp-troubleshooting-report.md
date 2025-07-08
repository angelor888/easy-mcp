# Easy-MCP Setup & Troubleshooting – Historical Report  
_Last updated: 2025-07-07 by Angelo & Claude_

---

## 1  Overview  

We spent several sessions repairing a broken Docker Compose stack for Easy-MCP, wiring it to Claude Desktop / Claude Code, and committing a formal SOP to GitHub.  
Key deliverables:

| Item | Status |
|------|--------|
| `docker-compose.yml` fixed | ✅ One `ports:` block per service, correct host mappings (8082 / 8084 / 8085 / 8086) |
| Containers start cleanly | ✅ `docker compose up -d` returns **no YAML errors** |
| Claude Code CLI alias | ✅ `claude-mcp` launches CLI from anywhere |
| Global git identity | ✅ `angelor888 / angelo@duetright.com` configured |
| SOP committed & pushed | ✅ `docs/mcp-setup-sop.md` on `main` |
| SOP posted to Slack | ✅ `#sop-library` |

---

## 2  Root Problems Encountered  

| Issue | Symptoms | Fix |
|-------|----------|-----|
| **Stray character in compose** | `yaml: could not find expected ':' (line 29)` | Deleted leading "W" at top of file |
| **Duplicate `ports:` key** | `mapping key "ports" already defined` | Removed second `ports:` block in service |
| **Mis-indentation** | Host port missing in `docker compose ps` | Ensured 4 spaces before `ports:`, 6 before dash |
| **Host-port mismatch** | `mcp-everything` exposed on 8082 instead of 8086 | Updated mapping to `"8086:8086"` |
| **curl reset errors** | `curl …/status` ⇒ connection reset | Expected — MCP isn't HTTP; use `/status` or `mcp list` instead |
| **Missing git identity** | `Author identity unknown` on commit | Set `git config user.email` + `user.name` |

---

## 3  Final Good State  

```text
docker compose ps
NAME                      PORTS
mcp-filesystem   0.0.0.0:8082->8082/tcp
mcp-puppeteer    0.0.0.0:8084->8084/tcp
mcp-memory       0.0.0.0:8085->8085/tcp
mcp-everything   0.0.0.0:8086->8086/tcp
```

All services running, accessible via Claude Desktop MCP integration.

---

## 4  Lessons Learned  

1. **YAML is picky**: Even one stray character breaks everything
2. **Indentation matters**: Docker Compose expects exact spacing for `ports:` blocks
3. **MCP ≠ HTTP**: These services speak MCP protocol over stdio, not HTTP
4. **Git config scope**: Use `--global` for cross-repo identity, local for project-specific
5. **Documentation wins**: Having a clear SOP prevents future confusion

---

## 5  Quick Recovery Commands  

```bash
# If containers won't start:
docker compose down
docker compose config    # validate YAML
docker compose up -d

# If MCP not connecting:
cp claude_desktop_config.json ~/Library/Application\ Support/Claude/
# Restart Claude Desktop

# Quick health check:
docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
```

---

_End of report_