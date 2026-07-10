# Design Spec: Differentiating Sound Notifications in play-sound

## Overview
Currently, the `play-sound` plugin plays the same sound (`Glass.aiff`) for both turn completion (`complete` event) and user approval requests (`approval` event).
This design specifies how to differentiate these sounds:
1. **Turn Completed / Message Ready**: A soft `Tink.aiff` chime.
2. **User Action / Approval Needed**: The existing `Glass.aiff` chime.

We will achieve this by dynamically selecting the sound file in `scripts/play-sound.sh` based on the event type argument. We will also allow optional environment overrides for configuration.

## Proposed Changes

### 1. `scripts/play-sound.sh`
Modify the script to select the sound file based on the first command-line argument:
- `complete` -> `Tink.aiff`
- `approval` -> `Glass.aiff`
- fallback -> `Glass.aiff`

```bash
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
```

### 2. `skills/play-sound/SKILL.md`
Update the skill description to reflect the differentiated sounds:
- Completion: Tink sound
- Approval: Glass sound

### 3. `README.md`
Update the README documentation:
- Explain that two different sounds are played depending on the event context.
- Document environment variables (`COMPLETE_SOUND`, `APPROVAL_SOUND`) that users can set to customize the sound paths.

## Testing & Verification Plan
1. Test script execution manually for both events:
   - Run `./scripts/play-sound.sh complete` -> verify a soft Tink sound plays.
   - Run `./scripts/play-sound.sh approval` -> verify a Glass sound plays.
2. Run `install.sh` to install the updated plugin globally.
3. Verify that agy plays the correct sound for actual life cycle events:
   - Turn completion should trigger Tink.
   - Any prompt requiring approval (e.g. `run_command`) should trigger Glass.
