#!/bin/sh
set -eux

TARGET="/session"
CONFIG_DIR="/home/osc/.config/open-stage-control"

# Create config directory and set ownership
mkdir -p "$CONFIG_DIR"
chown -R 1000:1000 "/home/osc/.config"

if [ -z "$(ls -A "$TARGET" 2>/dev/null || true)" ]; then
    cp /session-default/session.json $TARGET/session.json
    cp /session-default/session.state $TARGET/session.state
else
    echo "[init] $TARGET already populated, skipping."
fi

chown -R 1000:1000 "$TARGET"

gosu 1000:1000 xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" open-stage-control --disable-gpu --no-gui -s 0.0.0.0:7777 -l /session/session.json --state /session/session.state
