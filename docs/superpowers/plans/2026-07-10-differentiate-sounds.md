# play-sound Differentiate Sounds Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Differentiate sound notifications for turn completions (Tink sound) and user approvals (Glass sound) with environment variable overrides.

**Architecture:** Modify `scripts/play-sound.sh` to check the first argument (`complete` or `approval`), playing `Tink.aiff` and `Glass.aiff` respectively. Update README and SKILL files to document this.

**Tech Stack:** Bash, Markdown, macOS system sounds.

## Global Constraints
* Compatible with macOS native sounds in `/System/Library/Sounds/`.
* No external audio dependencies (uses standard `/usr/bin/afplay`).
* Async playback so command line performance is not degraded.

---

### Task 1: Update Sound Playback Script

**Files:**
- Modify: `/Users/giorgiolonardo/Development/skills/skill-sound/scripts/play-sound.sh`

**Interfaces:**
- Consumes: `EVENT_TYPE` via argument `$1`.
- Produces: Playback of Tink sound for completion, Glass sound for approvals.

- [ ] **Step 1: Modify play-sound.sh**
  Edit the script to conditionally assign `SOUND_FILE` using `Tink.aiff` for `complete` and `Glass.aiff` for `approval`, with support for environment overrides (`COMPLETE_SOUND` and `APPROVAL_SOUND`).
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

- [ ] **Step 2: Test the completion sound manually**
  Run: `/Users/giorgiolonardo/Development/skills/skill-sound/scripts/play-sound.sh complete`
  Expected: You hear a soft, high-pitched Tink chime.

- [ ] **Step 3: Test the approval sound manually**
  Run: `/Users/giorgiolonardo/Development/skills/skill-sound/scripts/play-sound.sh approval`
  Expected: You hear a Glass chime.

- [ ] **Step 4: Test custom environment variable override**
  Run: `COMPLETE_SOUND="/System/Library/Sounds/Purr.aiff" /Users/giorgiolonardo/Development/skills/skill-sound/scripts/play-sound.sh complete`
  Expected: You hear a Purr sound instead of the Tink sound.

- [ ] **Step 5: Commit**
  ```bash
  git add scripts/play-sound.sh
  git commit -m "feat: differentiate complete and approval sounds in script"
  ```

---

### Task 2: Update Documentation and Skill Definition

**Files:**
- Modify: `/Users/giorgiolonardo/Development/skills/skill-sound/skills/play-sound/SKILL.md`
- Modify: `/Users/giorgiolonardo/Development/skills/skill-sound/README.md`

- [ ] **Step 1: Update SKILL.md**
  Update the skill definition file to describe the two distinct sounds.
  ```markdown
  ---
  name: play-sound
  description: Use when you want to enable audible sound alerts in agy on macOS for turn completions or user approval prompts.
  ---

  # Play Sound

  This skill enables agy to play a chime when:
  1. The execution loop finishes and waits for user input (plays **Tink** sound).
  2. A tool (e.g. `run_command`) requires explicit user approval (plays **Glass** sound).
  ```

- [ ] **Step 2: Update README.md**
  Update the README file to document the Tink and Glass sounds, as well as the new configuration environment variables:
  - `COMPLETE_SOUND`: Path to a custom sound file for completed turns (default: `Tink.aiff`).
  - `APPROVAL_SOUND`: Path to a custom sound file for approval requests (default: `Glass.aiff`).
  ```markdown
  # Antigravity CLI Sound Notifications (`play-sound`)

  A global plugin and skill for the Google Antigravity CLI (`agy`) that chimes when your agent needs input or approval on macOS.

  Offer me a coffee if this skill is useful for you: https://buymeacoffee.com/mrtobor

  ## How it Works
  Audible sounds notify you when:
  * An execution turn completes and agy is waiting for your next text input (plays **Tink** chime).
  * A command or tool waits for your explicit approval, such as `run_command`, `ask_permission`, or `ask_question` (plays **Glass** chime).

  ## Installation
  1. Clone this repository or copy the directory.
  2. Run the installation script:
     ```bash
     chmod +x install.sh
     ./install.sh
     ```

  ## Configuration & Customization
  To change the sounds, you can set the following environment variables in your shell profile (e.g., `~/.zshrc`):
  * `COMPLETE_SOUND`: Path to any custom audio file (e.g. `/System/Library/Sounds/Ping.aiff`) to be played when a turn completes.
  * `APPROVAL_SOUND`: Path to any custom audio file (e.g. `/System/Library/Sounds/Submarine.aiff`) to be played when user approval is needed.

  Alternatively, you can edit the script directly at `~/.gemini/config/plugins/play-sound/scripts/play-sound.sh` and edit the default file paths.

  ## Support

  If this skill is useful for you, feel free to buy me a coffee!
  [Buy Me a Coffee ☕](https://buymeacoffee.com/mrtobor)
  ```

- [ ] **Step 3: Commit**
  ```bash
  git add skills/play-sound/SKILL.md README.md
  git commit -m "docs: document Tink/Glass sounds and customization env vars"
  ```

---

### Task 3: Reinstall and Verify Integration

**Files:**
- Modify: (None, verification only)

- [ ] **Step 1: Execute installer**
  Run: `/Users/giorgiolonardo/Development/skills/skill-sound/install.sh`
  Expected: Prints installation success messages.

- [ ] **Step 2: Verify files copied**
  Verify the script at `~/.gemini/config/plugins/play-sound/scripts/play-sound.sh` contains the updated logic.
  Run: `cat ~/.gemini/config/plugins/play-sound/scripts/play-sound.sh`
  Expected: Outputs the updated script contents.
