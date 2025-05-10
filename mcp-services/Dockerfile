FROM node:22.12-alpine AS builder
WORKDIR /app

# 複製整個 package.json 和 tsconfig.json
COPY package.json package-lock.json tsconfig.json ./

# 安裝所有依賴
RUN npm install

# 複製源代碼
COPY . .

# 構建特定的 workspace 包
RUN npm run build --workspace=@modelcontextprotocol/server-filesystem

FROM node:22-alpine AS release
WORKDIR /app

# 複製構建產物和配置檔案
COPY --from=builder /app/node_modules/@modelcontextprotocol/server-filesystem/dist /app/dist
COPY --from=builder /app/node_modules/@modelcontextprotocol/server-filesystem/package.json /app/package.json
# 如果 server-filesystem 也有 package-lock.json (通常 workspace 不會有獨立的 lock 檔，但以防萬一)
# COPY --from=builder /app/node_modules/@modelcontextprotocol/server-filesystem/package-lock.json /app/package-lock.json

ENV NODE_ENV=production
RUN npm install --omit=dev --ignore-scripts

ENTRYPOINT ["node", "/app/dist/index.js"]
EXPOSE 8082
