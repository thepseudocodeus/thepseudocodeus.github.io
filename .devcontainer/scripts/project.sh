#!/usr/bin/env bash
set -euo pipefail

LOG_FILE=".devcontainer/logs/project.log"
STATE_FILE=".devcontainer/state.env"

mkdir -p .devcontainer/logs
touch "$LOG_FILE"
touch "$STATE_FILE"

echo "🏗️ Starting project-specific setup and verification..." | tee -a "$LOG_FILE"

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

# ========= Smoke Test Python Imports =========
echo "🔍 Running import smoke test..." | tee -a "$LOG_FILE"

if [ -f "pyproject.toml" ]; then
    # List packages from poetry
    PACKAGES=$(poetry export -f requirements.txt --without-hashes | awk '{print $1}' | grep -v "^$")
    IMPORT_FAIL=0
    for pkg in $PACKAGES; do
        python -c "import $pkg" 2>/dev/null || {
            echo "❌ Failed to import $pkg" | tee -a "$LOG_FILE"
            IMPORT_FAIL=1
        }
    done
    if ((IMPORT_FAIL == 0)); then
        echo "✅ All project packages imported successfully" | tee -a "$LOG_FILE"
        echo "smoke_test=ok" >>"$STATE_FILE"
    else
        echo "⚠️ Some imports failed" | tee -a "$LOG_FILE"
        echo "smoke_test=fail" >>"$STATE_FILE"
    fi
else
    echo "ℹ️ pyproject.toml not found, skipping import smoke test" | tee -a "$LOG_FILE"
    echo "smoke_test=skipped" >>"$STATE_FILE"
fi

# ========= Optional Project Scripts =========
if [ -d ".devcontainer/scripts/project_extra" ]; then
    echo "⚙️ Running extra project scripts..." | tee -a "$LOG_FILE"
    for script in .devcontainer/scripts/project_extra/*.sh; do
        [ -x "$script" ] || chmod +x "$script"
        retry 2 bash "$script" | tee -a "$LOG_FILE"
    done
    echo "project_extra=ok" >>"$STATE_FILE"
else
    echo "ℹ️ No extra project scripts found" | tee -a "$LOG_FILE"
    echo "project_extra=skipped" >>"$STATE_FILE"
fi

# ========= Final Verification =========
echo "🔧 Verifying Python environment..." | tee -a "$LOG_FILE"
python -m pip check 2>&1 | tee -a "$LOG_FILE" || echo "⚠️ Some Python packages may have conflicts" | tee -a "$LOG_FILE"

echo "✅ Project-specific setup complete." | tee -a "$LOG_FILE"
