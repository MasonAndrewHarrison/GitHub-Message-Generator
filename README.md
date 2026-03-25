# GitHub Message Generator

**I created this because I don't like writing git commit messages and is created specifically for Code-OSS, although it should work in any terminal.**

## Features

* Generates commit messages from your staged changes
* Uses a local LLM (no API keys required)
* Fast and simple CLI workflow
* Works directly with your existing Git setup




## Requirements

* Linux or WSL (Windows users should use WSL)
   >Why the Hell would you be using Windows
* ~6 GB of VRAM for Qwen2.5-Code 7B
   >8 GB of VRAM is more stable\
   >Qwen2.5-Code 3B and 14B both work although you would need to change the python code





## Setup (Linux / WSL)

### 1. Install Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### 2. Pull the model

```bash
ollama pull qwen2.5-coder:7b
```

### 3. Install Python dependencies

```bash
pip install requests --break-system-packages
```

### 4. Enable the command

```bash
chmod +x ~/GitHub-Message-Generator/ai-commit.sh
echo "alias ai-commit='~/GitHub-Message-Generator/ai-commit.sh'" >> ~/.bashrc
source ~/.bashrc
```





## Usage

### Step by step
```bash
git add .        # stage your changes
ai-commit        # generate and commit
git push         # push to remote
```

### All in one step
```bash
ai-commit --all --push
```

### Flags
| Flag | Description |
|------|-------------|
| `--all` | Stage all changes before committing |
| `--push` | Push to remote after committing |
| `--dry-run` | Show commit message without committing |
| `--verbose` | Show full diff being sent to the model |
| `--help` | Show help message |





## Use with GUI (VS-Code, Open-OSS, VS-Codium)

### Search for **"Task Buttons"** by spencerwmiles in the extensions panel.

#### or

### Install the Task Buttons extension
```bash
# VS Code
code --install-extension spencerwmiles.vscode-task-buttons

# Code - OSS
code-oss --install-extension spencerwmiles.vscode-task-buttons

# VSCodium
codium --install-extension spencerwmiles.vscode-task-buttons

# Cursor
cursor --install-extension spencerwmiles.vscode-task-buttons
```

Add these to your `settings.json` (`Ctrl+Shift+P` → "Open User Settings JSON"):
```json
"VsCodeTaskButtons.tasks": [
    {
        "label": "$(git-commit) AI Commit",
        "task": "AI Commit"
    }
]
```
Copy [tasks.json](/tasks.json) to the appropriate location for your editor:

| Editor | Path |
|--------|------|
| VS Code | `~/.config/Code/User/tasks.json` |
| Code - OSS | `~/.config/Code - OSS/User/tasks.json` |
| VSCodium | `~/.config/VSCodium/User/tasks.json` |
| Cursor | `~/.config/Cursor/User/tasks.json` |




## Example Output

```
feat: add saliency map generation for PyTorch model

- implemented gradient-based visualization
- added utility function for image preprocessing
- updated training script to support saliency output
```



## Credits
- [Task Buttons](https://github.com/spencerwmiles/vscode-task-buttons) by spencerwmiles
- [Ollama](https://github.com/ollama/ollama) for local LLM inference
- [Qwen2.5-Coder](https://github.com/QwenLM/Qwen2.5-Coder) by Alibaba Cloud
