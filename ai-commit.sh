#!/bin/bash

if ! systemctl is-active --quiet ollama; then
    echo "Starting ollama..."
    sudo systemctl start ollama
    sleep 2
fi

if git diff --staged --quiet; then
    echo "No staged changes — run 'git add' first"
    exit 1
fi

SCRIPT_PATH=${1:-~/GitHub-Message-Generator}
if ! python3 "$SCRIPT_PATH/python.py"; then
    echo "Failed to run the Python script. Check the path or script."
    exit 1
fi
