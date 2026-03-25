#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Handle flags
DRY_RUN=""
VERBOSE=""
ALL=""

for arg in "$@"; do
    case $arg in
        --dry-run)  DRY_RUN="--dry-run" ;;
        --verbose)  VERBOSE="--verbose" ;;
        --all)      ALL="--all" ;;
        --help)
            echo "Usage: ai-commit [options]"
            echo "  --dry-run   Show commit message without committing"
            echo "  --verbose   Show full diff being sent to model"
            echo "  --all       Stage all changes before committing (git add .)"
            echo "  --help      Show this help message"
            exit 0
            ;;
    esac
done

if [ -n "$ALL" ]; then
    echo "Staging all changes..."
    git add .
fi

if ! systemctl is-active --quiet ollama; then
    echo "Starting ollama..."
    sudo systemctl start ollama
    sleep 2
fi

if git diff --staged --quiet; then
    echo "No staged changes — run 'git add' first or use --all"
    exit 1
fi

python3 "$SCRIPT_DIR/python.py" $DRY_RUN $VERBOSE