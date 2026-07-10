#!/bin/bash
# play-sound.sh: Emits system sounds for agy events

EVENT_TYPE="${1:-default}"

# Select sound based on event type with environment variable overrides
if [ "$EVENT_TYPE" = "complete" ]; then
  SOUND_FILE="${COMPLETE_SOUND:-/System/Library/Sounds/Tink.aiff}"
elif [ "$EVENT_TYPE" = "approval" ]; then
  SOUND_FILE="${APPROVAL_SOUND:-/System/Library/Sounds/Glass.aiff}"
else
  SOUND_FILE="${SOUND_FILE:-/System/Library/Sounds/Glass.aiff}"
fi

# Call check_sound.py to decide if we should play the sound
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if python3 "$SCRIPT_DIR/check_sound.py" "$EVENT_TYPE"; then
  if [ -f "$SOUND_FILE" ]; then
    /usr/bin/afplay "$SOUND_FILE" >/dev/null 2>&1 &
  fi
fi
