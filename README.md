# GitHub Message Generator

**I created this because I don't like writing git commit messages and is created specifically for Code-OSS, although it should work in any terminal.**
---

## Features

* Generates commit messages from your staged changes
* Uses a local LLM (no API keys required)
* Fast and simple CLI workflow
* Works directly with your existing Git setup

---


## Requirements

* Linux or WSL (Windows users should use WSL)
   >Why the Hell would you be using Windows
* ~6 GB of VRAM for Qwen2.5-Code 7B
   >8 GB of VRAM is more stable\
   >Qwen2.5-Code 3B and 14B both work although you would need to change the python code

---

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

---

## Usage

```bash
git add .
ai-commit
git push
```

---

## Example Output

```
feat: add saliency map generation for PyTorch model

- implemented gradient-based visualization
- added utility function for image preprocessing
- updated training script to support saliency output
```

