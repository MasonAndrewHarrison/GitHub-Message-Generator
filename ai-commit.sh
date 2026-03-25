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
        --push)     PUSH="--push" ;;
        --help)
            echo "Usage: ai-commit [options]"
            echo "  --dry-run   Show commit message without committing"
            echo "  --verbose   Show full diff being sent to model"
            echo "  --all       Stage all changes before committing (git add .)"
            echo "  --push      Push to remote after committing"
            echo "  --help      Show this help message"
            exit 0
            ;;
    esac
done

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Not a git repository"
    exit 1
fi

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
    exit 0
fi

python3 "$SCRIPT_DIR/python.py" $DRY_RUN $VERBOSE

if [ -n "$PUSH" ] && [ -z "$DRY_RUN" ]; then
    echo "Pushing to remote..."
    git push
fi