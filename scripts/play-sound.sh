#!/bin/bash
# play-sound.sh: Emits system sounds for agy events

EVENT_TYPE=$1
SOUND_FILE="/System/Library/Sounds/Glass.aiff"

# Print log message for debugging (redirected or silent in normal operation)
# echo "agy event: $EVENT_TYPE. Playing notification sound..."

if [ -f "$SOUND_FILE" ]; then
  /usr/bin/afplay "$SOUND_FILE" &
fi
