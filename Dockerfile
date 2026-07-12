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
# Installing core tools and extensions explicitly to maximize Docker layer caching
RUN npm install -g @robzolkos/lazypi
RUN npm install -g pi-subagents
RUN npm install -g pi-mcp-adapter
RUN npm install -g pi-web-access
RUN npm install -g pi-memory-md
RUN npm install -g pi-plan
RUN npm install -g pi-simplify
RUN npm install -g pi-add-dir
RUN npm install -g pi-prompt-template-model
RUN npm install -g pi-claude-cli
RUN npm install -g @plannotator/pi-extension
RUN npm install -g pi-slopchop
RUN npm install -g pi-powerbar
RUN npm install -g pi-extension-settings
RUN npm install -g pi-usage-extension
RUN npm install -g @tmustier/pi-raw-paste
RUN npm install -g pi-manage-todo-list
RUN npm install -g pi-btw
RUN npm install -g pi-autoresearch
RUN npm install -g pi-ralph-wiggum

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
