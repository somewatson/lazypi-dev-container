# LazyPi Development Container

An Ubuntu-based ARM64 compatible environment with ZSH, Oh My Zsh, Node.js, and LazyPi.

## Quick Start

1. **Configure Permissions**:
   Copy the `.env.example` to `.env` and set your host UID/GID:
   ```bash
   cp .env.example .env
   ```

2. **Build and Start**:
   ```bash
   docker compose up -d
   ```

3. **Enter the Container**:
   Use the provided helper script:
   ```bash
   ./dev-shell
   ```


## Features
- **Ubuntu Base**: Familiar and easy to use.
- **ARM64 Compatible**: Works on Apple Silicon and ARM64 servers.
- **ZSH + Oh My Zsh**: Pre-configured shell.
- **LazyPi**: Pre-installed with all packages.
- **Docker-out-of-Docker**: Access the host Docker daemon via `/var/run/docker.sock`.
- **Persistent Config**: Model configurations are saved in the `./lazypi_config` folder on your host.
- **Local Workspace**: The current directory is mounted to `/home/dev/workspace`.

## Updating Models

You can add custom providers and models via `/home/dev/.pi/agent/models.json` (mapped to the `./lazypi_config` folder on your host). 

### 🛠️ Host Setup for Local Models

Since we use a bind mount for persistence, you should create the configuration directory and file on your **host machine** before starting the container. This ensures the settings are preserved and easy to edit.

1. **Create the config directory**:
   ```bash
   mkdir -p ./lazypi_config/agent
   ```

2. **Create the `models.json` file**:
   Create `./lazypi_config/agent/models.json` with your provider details. For example, if using Ollama on the host:
   ```json
   {
     "providers": {
       "ollama": {
         "baseUrl": "http://host.docker.internal:11434/v1",
         "api": "openai-completions",
         "apiKey": "ollama",
         "models": [
           { "id": "llama3.1:8b" },
           { "id": "qwen2.5-coder:7b" }
         ]
       }
     }
   }
   ```

3. **Start the container**:
   Now run `docker compose up -d`. The container will automatically map `./lazypi_config` to `/home/dev/.pi`, making your `models.json` available immediately.

For more details, visit the [official documentation](https://pi.dev/docs/latest/models#minimal-example).

## Updating LazyPi Packages

The container pre-installs the latest LazyPi package set during the build process. To update these packages to the latest versions:

1. **Rebuild the container** (Recommended):
   ```bash
   docker compose up -d --build
   ```
2. **Update while running**: If you are already inside the container, you can run the installer again:
   ```bash
   npx @robzolkos/lazypi
   ```

## Persistence & Package Management

To keep the environment fast and consistent, this container uses a hybrid approach to package management:

### 1. System Tools (Baked-in)
Core tools and the initial LazyPi package set are installed during the image build. These are stored in the container's read-only layers for maximum performance.
- **To update**: Run `docker compose up -d --build`.
- **To add permanently**: Add the package to the `Dockerfile` and rebuild.

### 2. User Tools (Persistent)
If you need additional tools that survive container recreations, avoid `npm install -g`. Instead, use one of these methods:

- **Project Local (Recommended)**: Install packages directly in your workspace:
  ```bash
  npm install <package-name>
  ```
  Since the workspace is mounted to your host, these are saved in `node_modules` on your disk and persist forever. Run them using `npx <package-name>`.

- **On-Demand**: For tools you use occasionally, skip installation entirely:
  ```bash
  npx <package-name>
  ```

## Credits
This project was created by [Some Watson](https://somewatson.com/) with the assistance of opencode, an AI software engineering agent.
