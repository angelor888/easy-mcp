# Standard Operating Procedure

## Title
MCP Docker Stack Setup and Maintenance

## Purpose
Establish standardized procedures for setting up, maintaining, and troubleshooting the Easy-MCP Docker stack for Claude Desktop integration.

## Scope
Applies to all MCP (Model Context Protocol) service deployments for DuetRight development environments.

## Procedure

### 1. Initial Setup
1. **Clone Repository**
   ```bash
   git clone https://github.com/angelor888/easy-mcp.git
   cd easy-mcp
   ```

2. **Validate Configuration**
   ```bash
   docker compose config
   ```

3. **Start Services**
   ```bash
   docker compose up -d
   ```

4. **Verify All Services Running**
   ```bash
   docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
   ```
   - Filesystem: Port 8082
   - Puppeteer: Port 8084
   - Memory: Port 8085
   - Everything: Port 8086

### 2. Claude Desktop Integration
1. **Copy Configuration**
   ```bash
   cp claude_desktop_config.json ~/Library/Application\ Support/Claude/
   ```

2. **Restart Claude Desktop**
   - Quit Claude Desktop completely (Cmd+Q)
   - Relaunch Claude Desktop

3. **Verify Connection**
   - In Claude Desktop, type: `/status` or `mcp list`
   - Should show all 4 services with ✓

### 3. Daily Maintenance
1. **Morning Check (9:00 AM)**
   - Run: `docker compose ps`
   - Verify all containers "Up"
   - Check logs: `docker compose logs --tail=50`

2. **Quick Health Check**
   ```bash
   docker compose ps | grep -v "Up" | wc -l
   ```
   - Result should be 1 (header line only)

### 4. Troubleshooting

#### Issue: Services Not Starting
```bash
docker compose down -v
docker system prune -f
docker compose up -d
```

#### Issue: Port Conflicts
```bash
lsof -i :8082,8084,8085,8086
# Kill conflicting processes or change ports in docker-compose.yml
```

#### Issue: Claude Not Connecting
1. Verify config file location
2. Check service logs: `docker compose logs [service-name]`
3. Restart both Docker services and Claude Desktop

### 5. Shutdown Procedure
```bash
docker compose down
```

## Responsibilities
- **Developer**: Follow setup procedures, perform daily checks
- **DevOps Lead**: Maintain Docker images, update configurations
- **Team Lead**: Approve configuration changes

## Version History
- v1.0 (2025-01-08): Initial SOP created

---
*End of Document*