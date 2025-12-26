#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Running devcontainer setup via orchestrator..."

# Make sure orchestrator is executable
chmod +x .devcontainer/scripts/orchestrator.sh

# Run orchestrator
bash .devcontainer/scripts/orchestrator.sh

echo "✅ Setup complete! All stages executed."
