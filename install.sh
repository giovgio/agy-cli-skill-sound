#!/bin/bash
# install.sh: Installs the play-sound plugin and skill globally

set -e

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "Error: play-sound is only supported on macOS." >&2
  exit 1
fi

PLUGIN_DIR="$HOME/.gemini/config/plugins/play-sound"
SKILL_DIR="$HOME/.gemini/config/skills/play-sound"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing play-sound plugin and skill..."

# Create directories
mkdir -p "$PLUGIN_DIR/scripts"
mkdir -p "$SKILL_DIR"

# Copy files
cp "$SCRIPT_DIR/plugin.json" "$PLUGIN_DIR/"
cp "$SCRIPT_DIR/scripts/play-sound.sh" "$PLUGIN_DIR/scripts/"
cp "$SCRIPT_DIR/scripts/check_sound.py" "$PLUGIN_DIR/scripts/"
chmod +x "$PLUGIN_DIR/scripts/play-sound.sh"
chmod +x "$PLUGIN_DIR/scripts/check_sound.py"

cp "$SCRIPT_DIR/skills/play-sound/SKILL.md" "$SKILL_DIR/"

# Dynamically build hooks.json replacing HOOK_PLAY_COMMAND with absolute path
HOOK_PLAY_COMMAND="$PLUGIN_DIR/scripts/play-sound.sh"
sed "s|HOOK_PLAY_COMMAND|$HOOK_PLAY_COMMAND|g" "$SCRIPT_DIR/hooks.json" > "$PLUGIN_DIR/hooks.json"

echo "play-sound installed successfully!"
echo "Plugin registered at: $PLUGIN_DIR"
echo "Skill registered at: $SKILL_DIR"
