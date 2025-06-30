FROM node:22-alpine

# 設置工作目錄
WORKDIR /app

# 安裝 everything 服務器（全局安裝）
RUN npm install -g @modelcontextprotocol/server-everything

# 設置環境變數
ENV NODE_ENV=production
ENV PORT=8086

# 創建非 root 用戶
RUN addgroup -g 1001 -S mcp && \
    adduser -S mcp -u 1001 -G mcp && \
    chown -R mcp:mcp /app

# 切換到非 root 用戶
USER mcp

# 使用官方 everything 服務器
ENTRYPOINT ["mcp-server-everything"]
EXPOSE ${PORT} 