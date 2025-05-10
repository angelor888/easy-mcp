FROM node:22.12-alpine AS builder
WORKDIR /app

# 複製整個 package.json 和 tsconfig.json
COPY package.json package-lock.json tsconfig.json ./

# 安裝所有依賴
RUN npm install

# 複製源代碼
COPY . .

# 構建特定的 workspace 包
RUN npm run build --workspace=@modelcontextprotocol/server-brave-search

FROM node:22-alpine AS release
WORKDIR /app

# 複製構建產物和配置檔案
COPY --from=builder /app/node_modules/@modelcontextprotocol/server-brave-search/dist /app/dist
COPY --from=builder /app/node_modules/@modelcontextprotocol/server-brave-search/package.json /app/package.json

# Port for Brave Search server (inside container)
ENV NODE_ENV=production
ENV PORT=8083

RUN npm install --omit=dev --ignore-scripts

ENTRYPOINT ["node", "/app/dist/index.js"]
EXPOSE ${PORT}
# If the server needs specific arguments (e.g. --port ${PORT}), add them in CMD
# CMD ["--port", "${PORT}"] 