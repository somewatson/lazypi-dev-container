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

### Minimal Example (Local Models)
If you are running Ollama or another local provider on your host machine, use `host.docker.internal` instead of `localhost`:

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

For more details, visit the [official documentation](https://pi.dev/docs/latest/models#minimal-example).

## Updating LazyPi Packages

The container pre-installs the latest LazyPi package set during the build process. To update these packages to the latest versions:

1. **Rebuild the container** (Recommended):
   ```bash
   docker-compose up -d --build
   ```
2. **Update while running**: If you are already inside the container, you can run the installer again:
   ```bash
   npx @robzolkos/lazypi
   ```

## Credits
This project was created by [Some Watson](https://somewatson.com/) with the assistance of opencode, an AI software engineering agent.
