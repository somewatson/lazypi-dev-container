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
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20 (LTS) - ARM64 compatible
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Create a non-root user 'dev'
RUN useradd -m -s /bin/zsh dev && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Pre-install LazyPi packages
# We install globally first to leverage Docker layer caching and avoid npx download overhead
RUN npm install -g @robzolkos/lazypi
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
