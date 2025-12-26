#!/usr/bin/env bash
set -euo pipefail

LOG_FILE=".devcontainer/logs/python.log"
STATE_FILE=".devcontainer/state.env"

mkdir -p .devcontainer/logs
touch "$LOG_FILE"
touch "$STATE_FILE"

echo "🐍 Starting Python & Conda environment checks..." | tee -a "$LOG_FILE"

# Load previous state
if [ -f "$STATE_FILE" ]; then
    source "$STATE_FILE"
fi

# Helper to retry commands
retry() {
    local -r -i max_attempts="$1"
    shift
    local -i attempt_num=1
    until "$@"; do
        if ((attempt_num == max_attempts)); then
            echo "❌ Command failed after $attempt_num attempts: $*" | tee -a "$LOG_FILE"
            return 1
        else
            echo "⚠️ Attempt $attempt_num failed, retrying in $attempt_num seconds..." | tee -a "$LOG_FILE"
            sleep $((attempt_num++))
        fi
    done
}

# ========= Conda =========
if command -v conda >/dev/null 2>&1; then
    CONDA=$(command -v conda)
elif [ -x "/opt/conda/bin/conda" ]; then
    CONDA="/opt/conda/bin/conda"
elif [ -x "/home/vscode/.local/bin/conda" ]; then
    CONDA="/home/vscode/.local/bin/conda"
else
    echo "⚠️ Conda not found, bootstrapping Miniconda..." | tee -a "$LOG_FILE"
    retry 3 bash -c "
        curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda.sh &&
        bash miniconda.sh -b -p /home/vscode/miniconda &&
        rm miniconda.sh
    "
    CONDA="/home/vscode/miniconda/bin/conda"
fi

export PATH="$(dirname $CONDA):$PATH"
eval "$($CONDA shell.bash hook 2>/dev/null)"

echo "✅ Conda available at $CONDA" | tee -a "$LOG_FILE"
echo "conda=ok" >>"$STATE_FILE"

# ========= Mamba =========
if command -v mamba >/dev/null 2>&1; then
    echo "✅ Mamba available at $(command -v mamba)" | tee -a "$LOG_FILE"
    echo "mamba=ok" >>"$STATE_FILE"
else
    echo "⚠️ Mamba not found, installing via Conda..." | tee -a "$LOG_FILE"
    retry 3 $CONDA install -y -c conda-forge mamba
    echo "mamba=ok" >>"$STATE_FILE"
fi

# ========= Python version =========
PY_VER=$(python --version 2>&1)
echo "🐍 Python version detected: $PY_VER" | tee -a "$LOG_FILE"
echo "python_version=$PY_VER" >>"$STATE_FILE"

echo "✅ Python & Conda checks complete." | tee -a "$LOG_FILE"
