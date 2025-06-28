FROM node:22.12-alpine AS builder
WORKDIR /app

# 安裝 Git（用於專案檢測）
RUN apk add --no-cache git

# 複製 package.json 文件
COPY package.json package-lock.json tsconfig.json ./

# 安裝所有依賴
RUN npm install

# 複製源代碼
COPY . .

# 構建增強版 Memory 服務（基於 knowledge-graph）
RUN npm run build --workspace=@modelcontextprotocol/server-memory

FROM node:22-alpine AS release
WORKDIR /app

# 安裝 Git 和增強功能所需的工具
RUN apk add --no-cache git curl

# 複製構建產物
COPY --from=builder /app/node_modules/@modelcontextprotocol/server-memory/dist /app/dist
COPY --from=builder /app/node_modules/@modelcontextprotocol/server-memory/package.json /app/package.json

# 創建數據和配置目錄
RUN mkdir -p /app/data /app/contexts /app/projects

# 設置環境變數
ENV NODE_ENV=production
ENV PORT=8085
ENV MEMORY_FILE_PATH=/app/data/memory.jsonl
ENV CONTEXTS_FILE_PATH=/app/contexts/contexts.json

# 安裝生產依賴和增強功能
RUN npm install --omit=dev --ignore-scripts && \
    npm install -g mcp-knowledge-graph@latest

# 創建優化的啟動腳本
RUN echo '#!/bin/sh\n\
# 初始化上下文配置\n\
if [ ! -f "$CONTEXTS_FILE_PATH" ]; then\n\
  mkdir -p "$(dirname "$CONTEXTS_FILE_PATH")"\n\
  echo "{\n\
    \"activeContext\": \"default\",\n\
    \"contexts\": [\n\
      {\n\
        \"name\": \"default\",\n\
        \"path\": \"/app/data/memory.jsonl\",\n\
        \"isProjectBased\": false,\n\
        \"description\": \"Default memory context\"\n\
      },\n\
      {\n\
        \"name\": \"project-specific\",\n\
        \"path\": \"{projectDir}/.ai-memory.jsonl\",\n\
        \"isProjectBased\": true,\n\
        \"description\": \"Project-specific memories\",\n\
        \"projectDetectionRules\": {\n\
          \"markers\": [\"package.json\", \".git\", \"pyproject.toml\", \"docker-compose.yml\"],\n\
          \"maxDepth\": 5\n\
        }\n\
      }\n\
    ]\n\
  }" > "$CONTEXTS_FILE_PATH"\n\
fi\n\
\n\
# 啟動增強版知識圖譜服務\n\
exec mcp-knowledge-graph --memory-path="$MEMORY_FILE_PATH" --contexts-directory="/app/contexts"\n\
' > /app/start.sh && chmod +x /app/start.sh

ENTRYPOINT ["/app/start.sh"]
EXPOSE ${PORT} 