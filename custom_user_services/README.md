# Custom User Services

This directory is a placeholder for you to add your own Dockerized web applications or other services (e.g., a Next.js frontend, custom APIs, etc.) that you might want to run alongside the MCP (Model Context Protocol) services.

## How to Add Your Service

1.  **Create a Dockerfile**: Place the `Dockerfile` for your custom service within a subdirectory here (e.g., `custom_user_services/my_next_app/Dockerfile`).
2.  **Add Service to `docker-compose.yml`**:
    Open the main `docker-compose.yml` file in the project root.
    Add a new service definition for your application. Example:

    ```yaml
    services:
      # ... existing MCP services ...

      my-custom-app:
        build:
          context: ./custom_user_services/my_next_app # Path to your app's Dockerfile context
          dockerfile: Dockerfile
        container_name: my-custom-app-instance
        restart: unless-stopped
        ports:
          - "3000:3000" # Example port mapping
        networks:
          - app_net # Connect to the same network as MCP services if needed
        # Add other configurations like volumes, environment variables, etc.
    ```

3.  **Build and Run**:
    Run `docker-compose up --build -d` from the project root to build and start your new service along with the MCP services.

## Interacting with MCP Services

If your custom service needs to communicate with the MCP services (e.g., make HTTP requests to them), you can use their service names as hostnames within the Docker network (`app_net`). For example, to reach `mcp-filesystem` (which runs on port 8082 inside the Docker network), your custom application would make a request to `http://mcp-filesystem:8082`.

Refer to the main project `README.md` and `claude_desktop_config.json.example` for the ports and endpoints of the included MCP services.

---

# 自訂使用者服務

此目錄是一個預留位置，供您新增自己的 Docker 化 Web 應用程式或其他服務（例如 Next.js 前端、自訂 API 等），這些服務可以與 MCP (模型上下文協定) 服務一起運行。

## 如何新增您的服務

1.  **建立 Dockerfile**：將您自訂服務的 `Dockerfile` 放置在此處的子目錄中（例如 `custom_user_services/my_next_app/Dockerfile`）。
2.  **將服務加入 `docker-compose.yml`**：
    開啟專案根目錄中的主要 `docker-compose.yml` 檔案。
    為您的應用程式新增服務定義。範例如下：

    ```yaml
    services:
      # ... 現有的 MCP 服務 ...

      my-custom-app:
        build:
          context: ./custom_user_services/my_next_app # 指向您應用程式 Dockerfile 上下文的路徑
          dockerfile: Dockerfile
        container_name: my-custom-app-instance
        restart: unless-stopped
        ports:
          - "3000:3000" # 範例埠號映射
        networks:
          - app_net # 如果需要，連接到與 MCP 服務相同的網路
        # 新增其他設定，如磁碟區、環境變數等。
    ```

3.  **建置並執行**：
    從專案根目錄執行 `docker-compose up --build -d` 以建置並啟動您的新服務以及 MCP 服務。

## 與 MCP 服務互動

如果您的自訂服務需要與 MCP 服務通訊（例如，向它們發出 HTTP 請求），您可以在 Docker 網路 (`app_net`) 中使用它們的服務名稱作為主機名稱。例如，要連接到 `mcp-filesystem`（在 Docker 網路內部運行於埠號 8082），您的自訂應用程式將向 `http://mcp-filesystem:8082` 發出請求。

有關內含 MCP 服務的埠號和端點，請參閱主要專案的 `README.md` 和 `claude_desktop_config.json.example`。
