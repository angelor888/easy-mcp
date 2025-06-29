FROM node:22-alpine

# 安裝 Chromium 和相依套件
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont

# 設置工作目錄
WORKDIR /app

# 安裝 puppeteer 服務器（全局安裝）
RUN npm install -g @modelcontextprotocol/server-puppeteer

# 設置環境變數
ENV NODE_ENV=production
ENV PORT=8084
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# 創建非 root 用戶
RUN addgroup -g 1001 -S mcp && \
    adduser -S mcp -u 1001 -G mcp && \
    chown -R mcp:mcp /app

# 切換到非 root 用戶
USER mcp

# 使用官方 puppeteer 服務器
ENTRYPOINT ["mcp-server-puppeteer"]
EXPOSE ${PORT} 