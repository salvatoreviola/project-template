#!/usr/bin/env bash
set -euo pipefail

echo "================================="
echo "Setting up project (Python + Jupyter + LaTeX)..."
echo "================================="

# --- Python venv ---
if [ ! -d ".venv" ]; then
  echo "Creating virtual environment in .venv..."
  python3 -m venv .venv
else
  echo ".venv already exists."
fi

# shellcheck disable=SC1091
source .venv/bin/activate

echo "Upgrading pip..."
python -m pip install --upgrade pip

if [ -f requirements.txt ]; then
  echo "Installing Python dependencies from requirements.txt..."
  pip install -r requirements.txt
else
  echo "No requirements.txt found, skipping pip installs."
fi

# --- VS Code extensions (curated list only) ---
EXTENSIONS=(
  "ms-python.python"
  "ms-python.vscode-pylance"
  "ms-toolsai.jupyter"
  "James-Yu.latex-workshop"
)

if command -v code >/dev/null 2>&1; then
  echo "Installing VS Code extensions (curated list)..."
  for ext in "${EXTENSIONS[@]}"; do
    code --install-extension "$ext" --force
  done
else
  echo "VS Code CLI 'code' not found; skipping extension install."
  echo "Install VS Code and enable the 'code' command, then re-run setup."
fi

echo "================================="
echo "Setup complete."
echo "If experiencing complications, restart VS Code"
echo "To activate the environment later:"
echo "source .venv/bin/activate"
echo "================================="
