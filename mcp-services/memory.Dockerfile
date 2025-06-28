FROM node:22.12-alpine AS builder
WORKDIR /app

# 複製 package.json 和相關配置文件
COPY package.json package-lock.json tsconfig.json ./

# 安裝所有依賴
RUN npm install

# 複製源代碼
COPY . .

# 構建官方 Memory 服務
RUN npm run build --workspace=@modelcontextprotocol/server-memory

FROM node:22-alpine AS release
WORKDIR /app

# 複製構建產物
COPY --from=builder /app/node_modules/@modelcontextprotocol/server-memory/dist /app/dist
COPY --from=builder /app/node_modules/@modelcontextprotocol/server-memory/package.json /app/package.json

# 創建數據目錄
RUN mkdir -p /app/data

# 設置環境變數
ENV NODE_ENV=production
ENV PORT=8085
ENV MEMORY_FILE_PATH=/app/data/memory.json

# 安裝生產依賴
RUN npm install --omit=dev --ignore-scripts

# 使用官方 ENTRYPOINT
ENTRYPOINT ["node", "/app/dist/index.js"]
EXPOSE ${PORT} 