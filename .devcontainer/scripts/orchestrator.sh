#!/usr/bin/env bash
set -euo pipefail

MASTER_LOG=".devcontainer/logs/master.log"
STATE_FILE=".devcontainer/state.env"

mkdir -p .devcontainer/logs
touch "$MASTER_LOG"
touch "$STATE_FILE"

echo "🚀 Starting devcontainer orchestration..." | tee -a "$MASTER_LOG"

# Helper to run a stage with retries
run_stage() {
    local stage="$1"
    local retries="${2:-2}"
    local attempt=1

    while true; do
        echo "🔹 Running stage: $stage (attempt $attempt)" | tee -a "$MASTER_LOG"
        if bash "$stage"; then
            echo "✅ Stage $stage completed successfully" | tee -a "$MASTER_LOG"
            break
        else
            if ((attempt >= retries)); then
                echo "❌ Stage $stage failed after $attempt attempts" | tee -a "$MASTER_LOG"
                # Decide adaptive fallback if needed (could branch here)
                break
            else
                echo "⚠️ Stage $stage failed, retrying..." | tee -a "$MASTER_LOG"
                attempt=$((attempt + 1))
                sleep $attempt
            fi
        fi
    done
}

# ========= Run stages sequentially =========
run_stage ".devcontainer/scripts/base.sh" 2
run_stage ".devcontainer/scripts/python.sh" 3
run_stage ".devcontainer/scripts/dependencies.sh" 3
run_stage ".devcontainer/scripts/project.sh" 2

# ========= Final summary =========
echo "📄 Devcontainer setup summary:" | tee -a "$MASTER_LOG"
if [ -f "$STATE_FILE" ]; then
    cat "$STATE_FILE" | tee -a "$MASTER_LOG"
fi

echo "🚀 Devcontainer orchestration complete!" | tee -a "$MASTER_LOG"
