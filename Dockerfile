FROM debian:trixie-slim

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    zsh \
    ca-certificates \
    sudo \
    docker.io \
    build-essential \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20 (LTS) - ARM64 compatible
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Create a non-root user 'dev'
RUN useradd -m -s /bin/zsh dev && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Pre-install LazyPi packages
# We use background processes and 'wait' to parallelize downloads while keeping logical groups for caching
RUN npm install -g @robzolkos/lazypi && \
    npm install -g pi-subagents & \
    npm install -g pi-mcp-adapter & \
    npm install -g pi-web-access & \
    npm install -g pi-memory-md & \
    npm install -g pi-plan & \
    npm install -g pi-simplify & \
    npm install -g pi-add-dir & \
    npm install -g pi-prompt-template-model & \
    npm install -g pi-claude-cli & \
    wait

RUN npm install -g @plannotator/pi-extension & \
    npm install -g pi-slopchop & \
    npm install -g pi-powerbar & \
    npm install -g pi-extension-settings & \
    npm install -g pi-usage-extension & \
    npm install -g @tmustier/pi-raw-paste & \
    npm install -g pi-manage-todo-list & \
    npm install -g pi-btw & \
    wait

RUN npm install -g pi-autoresearch & \
    npm install -g pi-ralph-wiggum & \
    wait

# Run lazypi to catch any new default packages or configurations
RUN yes | lazypi || true

USER dev
WORKDIR /home/dev

# Install Oh My Zsh (unattended)
COPY --chown=dev:dev minimal.zshrc /home/dev/minimal.zshrc
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    cp /home/dev/minimal.zshrc /home/dev/.zshrc

# Set workspace directory
WORKDIR /home/dev/workspace

# Copy update prompt and add to zshrc
COPY --chown=dev:dev entry-prompt.zsh /home/dev/entry-prompt.zsh
RUN chmod +x /home/dev/entry-prompt.zsh && echo 'source /home/dev/entry-prompt.zsh' >> /home/dev/.zshrc

# Default command
CMD ["zsh"]
