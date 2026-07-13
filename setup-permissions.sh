#!/bin/bash
# Ensure the lazypi config directory and its subfolders are owned by the dev user
# This prevents "Permission denied" errors when accessing the volume from the host

CONFIG_DIR="/home/dev/.pi"
WORKSPACE_DIR="/home/dev/workspace"

if [ -d "$CONFIG_DIR" ]; then
    sudo chown -R dev:dev "$CONFIG_DIR"
    sudo mkdir -p "$CONFIG_DIR/agent"
    sudo chown -R dev:dev "$CONFIG_DIR/agent"
fi

if [ -d "$WORKSPACE_DIR" ]; then
    sudo chown -R dev:dev "$WORKSPACE_DIR"
fi

# Synchronize docker group ID with the host's docker socket
# This allows the 'dev' user to run docker commands without sudo
if [ -S /var/run/docker.sock ]; then
    DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
    
    # Check if a group with this GID already exists
    if getent group "$DOCKER_GID" > /dev/null; then
        # GID exists, find the group name and add dev to it
        EXISTING_GROUP=$(getent group "$DOCKER_GID" | cut -d: -f1)
        sudo usermod -aG "$EXISTING_GROUP" dev
    else
        # GID is free, create a new group and add dev to it
        sudo groupadd -g "$DOCKER_GID" host-docker
        sudo usermod -aG host-docker dev
    fi
fi
