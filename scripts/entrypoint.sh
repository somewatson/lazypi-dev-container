#!/bin/bash
printf "127.0.0.1 %s\n" "$(hostname)" >> /etc/hosts
/home/dev/setup-permissions.sh

# Pre-populate LazyPi settings if they are missing or empty
SETTINGS_FILE="/home/dev/.pi/agent/settings.json"
if [ ! -f "$SETTINGS_FILE" ] || [ "$(grep -c "packages" "$SETTINGS_FILE")" -eq 0 ]; then
    mkdir -p /home/dev/.pi/agent
    echo '{"packages": ["npm:pi-subagents", "npm:pi-ask-user", "npm:pi-mcp-adapter", "npm:pi-web-access", "git:github.com/VandeeFeng/pi-memory-md", "npm:@devkade/pi-plan", "npm:pi-simplify", "npm:pi-add-dir", "npm:pi-prompt-template-model", "npm:pi-claude-cli", "npm:@plannotator/pi-extension", "npm:pi-slopchop", "npm:@juanibiapina/pi-extension-settings", "npm:@juanibiapina/pi-powerbar", "npm:@tmustier/pi-usage-extension", "npm:@tmustier/pi-raw-paste", "git:github.com/tintinweb/pi-manage-todo-list@b75c449aa85ce328e9a8b632f62bf642aed40359", "npm:pi-btw", "npm:pi-interactive-shell", "git:github.com/davebcn87/pi-autoresearch", "npm:@tmustier/pi-ralph-wiggum", "npm:@every-env/compound-plugin", "git:github.com/javierportillo/pi-hackerman@63b0a3ef2c7b14985ffeb6cac44614ba59cd5693", "npm:@victor-software-house/pi-curated-themes", "npm:pi-terminal-theme"], "theme": "dark"}' > "$SETTINGS_FILE"
    chown -R dev:dev /home/dev/.pi
fi

exec "$@"
