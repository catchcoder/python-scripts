#!/usr/bin/env bash
set -euo pipefail

SKIP_RUN=0
if [[ "${1:-}" == "--skip-run" ]]; then
  SKIP_RUN=1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"
VENV_PYTHON="$VENV_DIR/bin/python"
REQUIREMENTS_FILE="$SCRIPT_DIR/requirements.txt"
TARGET_SCRIPT="$SCRIPT_DIR/mdns_browse.py"

if [[ ! -f "$REQUIREMENTS_FILE" ]]; then
  echo "requirements.txt not found at $REQUIREMENTS_FILE" >&2
  exit 1
fi

if [[ ! -f "$TARGET_SCRIPT" ]]; then
  echo "mdns_browse.py not found at $TARGET_SCRIPT" >&2
  exit 1
fi

if [[ ! -x "$VENV_PYTHON" ]]; then
  echo "Creating virtual environment at $VENV_DIR..."
  if command -v python3 >/dev/null 2>&1; then
    python3 -m venv "$VENV_DIR"
  elif command -v python >/dev/null 2>&1; then
    python -m venv "$VENV_DIR"
  else
    echo "Python is not installed or not on PATH." >&2
    exit 1
  fi
fi

echo "Upgrading pip in virtual environment..."
"$VENV_PYTHON" -m pip install --upgrade pip

echo "Installing dependencies from requirements.txt..."
"$VENV_PYTHON" -m pip install -r "$REQUIREMENTS_FILE"

if [[ "$SKIP_RUN" -eq 0 ]]; then
  echo "Running mdns_browse.py..."
  "$VENV_PYTHON" "$TARGET_SCRIPT"
else
  echo "Setup complete. Skipped running script because --skip-run was provided."
fi
