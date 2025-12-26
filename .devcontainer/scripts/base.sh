#!/usr/bin/env bash
set -euo pipefail

LOG_FILE=".devcontainer/logs/base.log"
STATE_FILE=".devcontainer/state.env"

mkdir -p .devcontainer/logs
touch "$LOG_FILE"
touch "$STATE_FILE"

echo "🔧 Starting base environment checks..." | tee -a "$LOG_FILE"

# Helper to check commands
check_cmd() {
    local cmd="$1"
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "✅ $cmd found at $(command -v $cmd)" | tee -a "$LOG_FILE"
        echo "$cmd=ok" >>"$STATE_FILE"
    else
        echo "❌ $cmd NOT found" | tee -a "$LOG_FILE"
        echo "$cmd=missing" >>"$STATE_FILE"
    fi
}

# Check essential system commands
for cmd in bash curl git tar unzip; do
    check_cmd "$cmd"
done

# Check apt-get availability
if command -v apt-get >/dev/null 2>&1; then
    echo "✅ apt-get available" | tee -a "$LOG_FILE"
    echo "apt-get=ok" >>"$STATE_FILE"
else
    echo "❌ apt-get not found" | tee -a "$LOG_FILE"
    echo "apt-get=missing" >>"$STATE_FILE"
fi

echo "✅ Base environment check complete." | tee -a "$LOG_FILE"
