FROM node:22-alpine AS builder

# 設置工作目錄
WORKDIR /app

# 安裝 filesystem 服務器（預安裝）
RUN npm install -g @modelcontextprotocol/server-filesystem

# 創建專案目錄
RUN mkdir -p /app/projects

# 設置環境變數
ENV NODE_ENV=production
ENV PORT=8082
ENV MCP_SERVICE_NAME=filesystem
ENV MCP_LOG_LEVEL=info

# 設置權限
RUN addgroup -g 1001 -S mcp && \
    adduser -S mcp -u 1001 -G mcp && \
    chown -R mcp:mcp /app && \
    chown -R mcp:mcp /usr/local/lib/node_modules

# 切換到非 root 用戶
USER mcp

# 使用官方 mcp-server-filesystem
ENTRYPOINT ["mcp-server-filesystem"]
CMD ["/app/projects"]
EXPOSE ${PORT} 