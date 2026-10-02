#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title aw
# @raycast.mode silent
# @raycast.argument1 {"type": "text", "placeholder": "App name (chrome, kitty, Slack, ...)"}
# @raycast.description Focus an app here, or create a new window when supported.

set -euo pipefail
exec "$HOME/.local/libexec/workspace-app.sh" "$@" 2>&1
