#!/usr/bin/env bash
set -euo pipefail

LOG_FILE=".devcontainer/logs/dependencies.log"
STATE_FILE=".devcontainer/state.env"

mkdir -p .devcontainer/logs
touch "$LOG_FILE"
touch "$STATE_FILE"

echo "📦 Starting Python tooling & dependencies setup..." | tee -a "$LOG_FILE"

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

# ========= Mamba & Conda PATH =========
if [ -n "${mamba-}" ]; then
    MAMBA=$(command -v mamba)
elif command -v mamba >/dev/null 2>&1; then
    MAMBA=$(command -v mamba)
else
    echo "❌ Mamba missing from previous stage, aborting." | tee -a "$LOG_FILE"
    exit 1
fi
export PATH="$(dirname $MAMBA):$PATH"

# ========= Install Poetry =========
if command -v poetry >/dev/null 2>&1; then
    echo "✅ Poetry already installed at $(command -v poetry)" | tee -a "$LOG_FILE"
    echo "poetry=ok" >>"$STATE_FILE"
else
    echo "⚠️ Poetry not found, installing via Mamba..." | tee -a "$LOG_FILE"
    retry 3 $MAMBA install -y -c conda-forge poetry
    echo "poetry=ok" >>"$STATE_FILE"
fi

# ========= Install other core tools =========
for tool in black pytest pre-commit; do
    if command -v $tool >/dev/null 2>&1; then
        echo "✅ $tool already installed" | tee -a "$LOG_FILE"
        echo "$tool=ok" >>"$STATE_FILE"
    else
        echo "⚠️ Installing $tool via Mamba..." | tee -a "$LOG_FILE"
        retry 3 $MAMBA install -y -c conda-forge $tool
        echo "$tool=ok" >>"$STATE_FILE"
    fi
done

# ========= Install project dependencies via Poetry =========
if [ -f "pyproject.toml" ]; then
    echo "📦 Installing project dependencies via Poetry..." | tee -a "$LOG_FILE"
    retry 3 poetry install --no-dev
    echo "project_dependencies=ok" >>"$STATE_FILE"
else
    echo "ℹ️ pyproject.toml not found, skipping project dependencies." | tee -a "$LOG_FILE"
    echo "project_dependencies=skipped" >>"$STATE_FILE"
fi

# ========= Pre-commit setup =========
if [ -f ".pre-commit-config.yaml" ]; then
    echo "🔧 Installing pre-commit hooks..." | tee -a "$LOG_FILE"
    retry 3 pre-commit install
    echo "pre_commit=ok" >>"$STATE_FILE"
else
    echo "ℹ️ .pre-commit-config.yaml not found, skipping pre-commit setup." | tee -a "$LOG_FILE"
    echo "pre_commit=skipped" >>"$STATE_FILE"
fi

echo "✅ Python tooling & dependencies setup complete." | tee -a "$LOG_FILE"
