#!/bin/bash
# Ensure the lazypi config directory and its subfolders are owned by the dev user
# This prevents "Permission denied" errors when accessing the volume from the host

CONFIG_DIR="/home/dev/.pi"

if [ -d "$CONFIG_DIR" ]; then
    sudo chown -R dev:dev "$CONFIG_DIR"
    sudo mkdir -p "$CONFIG_DIR/agent"
    sudo chown -R dev:dev "$CONFIG_DIR/agent"
fi
