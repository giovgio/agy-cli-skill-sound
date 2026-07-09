#!/bin/bash
# play-sound.sh: Emits system sounds for agy events

EVENT_TYPE="${1:-default}"
SOUND_FILE="/System/Library/Sounds/Glass.aiff"

# Call check_sound.py to decide if we should play the sound
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if python3 "$SCRIPT_DIR/check_sound.py" "$EVENT_TYPE"; then
  if [ -f "$SOUND_FILE" ]; then
    /usr/bin/afplay "$SOUND_FILE" >/dev/null 2>&1 &
  fi
fi
