#!/bin/bash
# Ensure the lazypi config directory and its subfolders are owned by the dev user
# This prevents "Permission denied" errors when accessing the volume from the host

CONFIG_DIR="/home/dev/.pi"

if [ -d "$CONFIG_DIR" ]; then
    sudo chown -R dev:dev "$CONFIG_DIR"
    sudo mkdir -p "$CONFIG_DIR/agent"
    sudo chown -R dev:dev "$CONFIG_DIR/agent"
fi

# Synchronize docker group ID with the host's docker socket
# This allows the 'dev' user to run docker commands without sudo
if [ -S /var/run/docker.sock ]; then
    DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
    sudo groupmod -g "$DOCKER_GID" docker
    sudo usermod -aG docker dev
fi
