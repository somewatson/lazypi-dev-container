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

# Install Node.js 22 (Current) - ARM64 compatible
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
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

RUN npm install -g pi-ask-user & \
    npm install -g pi-interactive-shell & \
    npm install -g @devkade/pi-plan & \
    npm install -g @juanibiapina/pi-powerbar & \
    npm install -g @juanibiapina/pi-extension-settings & \
    npm install -g @tmustier/pi-usage-extension & \
    npm install -g @every-env/compound-plugin & \
    npm install -g pi-hackerman & \
    npm install -g @victor-software-house/pi-curated-themes & \
    npm install -g pi-terminal-theme & \
    wait

# Pre-populate the LazyPi state file so the installer recognizes the global npm packages as already installed
RUN mkdir -p /root/.pi/agent && echo '{"packages": ["npm:pi-subagents", "npm:pi-ask-user", "npm:pi-mcp-adapter", "npm:pi-web-access", "git:github.com/VandeeFeng/pi-memory-md", "npm:@devkade/pi-plan", "npm:pi-simplify", "npm:pi-add-dir", "npm:pi-prompt-template-model", "npm:pi-claude-cli", "npm:@plannotator/pi-extension", "npm:pi-slopchop", "npm:@juanibiapina/pi-extension-settings", "npm:@juanibiapina/pi-powerbar", "npm:@tmustier/pi-usage-extension", "npm:@tmustier/pi-raw-paste", "git:github.com/tintinweb/pi-manage-todo-list@b75c449aa85ce328e9a8b632f62bf642aed40359", "npm:pi-btw", "npm:pi-interactive-shell", "git:github.com/davebcn87/pi-autoresearch", "npm:@tmustier/pi-ralph-wiggum", "npm:@every-env/compound-plugin", "git:github.com/javierportillo/pi-hackerman@63b0a3ef2c7b14985ffeb6cac44614ba59cd5693", "npm:@victor-software-house/pi-curated-themes", "npm:pi-terminal-theme"]}' > /root/.pi/agent/settings.json

# Run lazypi to catch any new default packages or configurations (now a no-op for the above)
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
COPY --chown=dev:dev setup-permissions.sh /home/dev/setup-permissions.sh
RUN chmod +x /home/dev/entry-prompt.zsh /home/dev/setup-permissions.sh && echo 'source /home/dev/entry-prompt.zsh' >> /home/dev/.zshrc

# Default command
CMD ["zsh"]
