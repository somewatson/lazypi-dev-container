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
    nano \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 22 (Current) - ARM64 compatible
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs

# Create a non-root user 'dev'
RUN useradd -m -s /bin/zsh dev && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Pre-install LazyPi packages
# Use xargs for parallel installation in small batches to balance speed and stability
RUN npm install -g @robzolkos/lazypi
RUN echo "pi-subagents pi-mcp-adapter pi-web-access pi-memory-md" | xargs -n 1 -P 4 npm install -g
RUN echo "pi-simplify pi-add-dir pi-prompt-template-model pi-claude-cli" | xargs -n 1 -P 4 npm install -g
RUN echo "@plannotator/pi-extension pi-slopchop @tmustier/pi-usage-extension @tmustier/pi-raw-paste" | xargs -n 1 -P 4 npm install -g
RUN echo "pi-manage-todo-list pi-btw pi-autoresearch @tmustier/pi-ralph-wiggum" | xargs -n 1 -P 4 npm install -g
RUN echo "pi-ask-user pi-interactive-shell @devkade/pi-plan @juanibiapina/pi-powerbar" | xargs -n 1 -P 4 npm install -g
RUN echo "@juanibiapina/pi-extension-settings @every-env/compound-plugin" | xargs -n 1 -P 4 npm install -g
RUN echo "@victor-software-house/pi-curated-themes pi-terminal-theme" | xargs -n 1 -P 4 npm install -g

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
