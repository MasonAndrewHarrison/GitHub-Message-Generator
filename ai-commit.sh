#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! systemctl is-active --quiet ollama; then
    echo "Starting ollama..."
    sudo systemctl start ollama
    sleep 2
fi

if git diff --staged --quiet; then
    echo "No staged changes — run 'git add' first"
    exit 1
fi

python3 "$SCRIPT_DIR/python.py" "$@"