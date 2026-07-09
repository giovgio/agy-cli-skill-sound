# play-sound Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a reusable, global Antigravity (`agy`) plugin and skill that plays sound notifications on macOS when agy needs user input/approval.

**Architecture:** A standalone plugin folder that contains hooks mapping macOS system sound triggers (`afplay`) to specific lifecycle events (`Stop` and `PreToolUse` for input-requiring tools), packaged with an installation script for easy global registration.

**Tech Stack:** Bash, JSON, Markdown, macOS native sound commands (`afplay`).

## Global Constraints
* Compatible with macOS native sounds in `/System/Library/Sounds/`.
* No external audio dependencies (uses standard `/usr/bin/afplay`).
* Async playback so command line performance is not degraded.

---

### Task 1: Initialize Plugin Manifest

**Files:**
- Create: `/Users/giorgiolonardo/Development/skills/skill-sound/plugin.json`

**Interfaces:**
- Produces: `plugin.json` containing plugin metadata.

- [ ] **Step 1: Write plugin.json**
  Write the manifest JSON defining the plugin metadata.
  ```json
  {
    "name": "play-sound",
    "version": "1.0.0",
    "description": "Emits sound notifications when agy finishes a turn or requires approval.",
    "author": "giorgiolonardo"
  }
  ```

- [ ] **Step 2: Verify file creation**
  Run: `cat /Users/giorgiolonardo/Development/skills/skill-sound/plugin.json`
  Expected: JSON prints correctly.

- [ ] **Step 3: Commit**
  ```bash
  git add skill-sound/plugin.json
  git commit -m "feat: initialize plugin manifest"
  ```

---

### Task 2: Implement Sound Playback Wrapper Script

**Files:**
- Create: `/Users/giorgiolonardo/Development/skills/skill-sound/scripts/play-sound.sh`

**Interfaces:**
- Consumes: Arguments to differentiate between turn completion (`complete`) and tool approval (`approval`).
- Produces: Async playback command of `/System/Library/Sounds/Glass.aiff`.

- [ ] **Step 1: Write play-sound.sh**
  Write the bash script wrapper to trigger sound playback.
  ```bash
  #!/bin/bash
  # play-sound.sh: Emits system sounds for agy events

  EVENT_TYPE=$1
  SOUND_FILE="/System/Library/Sounds/Glass.aiff"

  # Print log message for debugging (redirected or silent in normal operation)
  # echo "agy event: $EVENT_TYPE. Playing notification sound..."

  if [ -f "$SOUND_FILE" ]; then
    /usr/bin/afplay "$SOUND_FILE" &
  fi
  ```

- [ ] **Step 2: Make script executable**
  Run: `chmod +x /Users/giorgiolonardo/Development/skills/skill-sound/scripts/play-sound.sh`
  Expected: Command finishes successfully.

- [ ] **Step 3: Test play-sound.sh manually**
  Run: `/Users/giorgiolonardo/Development/skills/skill-sound/scripts/play-sound.sh test`
  Expected: You hear a pleasant Glass chime sound immediately.

- [ ] **Step 4: Commit**
  ```bash
  git add skill-sound/scripts/play-sound.sh
  git commit -m "feat: add play-sound script"
  ```

---

### Task 3: Implement Hooks Configuration

**Files:**
- Create: `/Users/giorgiolonardo/Development/skills/skill-sound/hooks.json`

**Interfaces:**
- Produces: `hooks.json` map binding lifecycle hooks to the script path.

- [ ] **Step 1: Write hooks.json**
  Write the hooks configuration structure mapping the events to `HOOK_PLAY_COMMAND`.
  ```json
  {
    "play-sound-turn-complete": {
      "Stop": [
        {
          "type": "command",
          "command": "HOOK_PLAY_COMMAND complete",
          "timeout": 5
        }
      ]
    },
    "play-sound-approval-needed": {
      "PreToolUse": [
        {
          "matcher": "run_command|ask_permission|ask_question",
          "hooks": [
            {
              "type": "command",
              "command": "HOOK_PLAY_COMMAND approval",
              "timeout": 5
            }
          ]
        }
      ]
    }
  }
  ```

- [ ] **Step 2: Verify hooks.json structure**
  Run: `cat /Users/giorgiolonardo/Development/skills/skill-sound/hooks.json`
  Expected: JSON structure is exactly matching.

- [ ] **Step 3: Commit**
  ```bash
  git add skill-sound/hooks.json
  git commit -m "feat: add hooks template configuration"
  ```

---

### Task 4: Create custom Antigravity Skill Definition

**Files:**
- Create: `/Users/giorgiolonardo/Development/skills/skill-sound/skills/play-sound/SKILL.md`

**Interfaces:**
- Produces: Custom skill reference doc enabling auto-discovery by agents.

- [ ] **Step 1: Write SKILL.md**
  Write the custom skill markdown reference file.
  ```markdown
  ---
  name: play-sound
  description: Use when you want to enable audible sound alerts in agy on macOS for turn completions or user approval prompts.
  ---

  # Play Sound Skill

  ## Overview
  Plays sound notifications on macOS to alert the user when agy requires input or action.

  ## Triggers
  1. **Turn completion (`Stop` event)**: A soft Glass sound chimes when the execution loop terminates, indicating it is waiting for your next text input.
  2. **User approval (`PreToolUse` event)**: The same Glass sound chimes when a tool (e.g. `run_command`, `ask_permission`, `ask_question`) is halted and waiting for user approval.
  ```

- [ ] **Step 2: Verify SKILL.md syntax**
  Run: `cat /Users/giorgiolonardo/Development/skills/skill-sound/skills/play-sound/SKILL.md`
  Expected: File prints with proper formatting.

- [ ] **Step 3: Commit**
  ```bash
  git add skill-sound/skills/play-sound/SKILL.md
  git commit -m "feat: add skill documentation"
  ```

---

### Task 5: Implement Automated Installation Script

**Files:**
- Create: `/Users/giorgiolonardo/Development/skills/skill-sound/install.sh`

**Interfaces:**
- Produces: `install.sh` executable.

- [ ] **Step 1: Write install.sh**
  Write the bash script that deploys the plugin and skill to the global `~/.gemini/` configuration paths.
  ```bash
  #!/bin/bash
  # install.sh: Installs the play-sound plugin and skill globally

  set -e

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
  chmod +x "$PLUGIN_DIR/scripts/play-sound.sh"

  cp "$SCRIPT_DIR/skills/play-sound/SKILL.md" "$SKILL_DIR/"

  # Dynamically build hooks.json replacing HOOK_PLAY_COMMAND with absolute path
  HOOK_PLAY_COMMAND="$PLUGIN_DIR/scripts/play-sound.sh"
  sed "s|HOOK_PLAY_COMMAND|$HOOK_PLAY_COMMAND|g" "$SCRIPT_DIR/hooks.json" > "$PLUGIN_DIR/hooks.json"

  echo "play-sound installed successfully!"
  echo "Plugin registered at: $PLUGIN_DIR"
  echo "Skill registered at: $SKILL_DIR"
  ```

- [ ] **Step 2: Make installation script executable**
  Run: `chmod +x /Users/giorgiolonardo/Development/skills/skill-sound/install.sh`
  Expected: Command succeeds.

- [ ] **Step 3: Commit**
  ```bash
  git add skill-sound/install.sh
  git commit -m "feat: add automated installer"
  ```

---

### Task 6: Implement Documentation (README)

**Files:**
- Create: `/Users/giorgiolonardo/Development/skills/skill-sound/README.md`

- [ ] **Step 1: Write README.md**
  Create the readme document explaining how to use, install, and customize the sound plugin.
  ```markdown
  # Antigravity CLI Sound Notifications (`play-sound`)

  A global plugin and skill for the Google Antigravity CLI (`agy`) that chimes when your agent needs input or approval on macOS.

  ## How it Works
  Audible Glass chime notifies you when:
  * An execution turn completes and agy is waiting for your next text input (`Stop`).
  * A command or tool waits for your explicit approval, such as `run_command`, `ask_permission`, or `ask_question` (`PreToolUse`).

  ## Installation
  1. Clone this repository or copy the directory.
  2. Run the installation script:
     ```bash
     chmod +x install.sh
     ./install.sh
     ```

  ## Configuration & Customization
  To change the sound file:
  Edit the script at `~/.gemini/config/plugins/play-sound/scripts/play-sound.sh` and point `SOUND_FILE` to any custom audio path (e.g. `/System/Library/Sounds/Ping.aiff` or `/System/Library/Sounds/Submarine.aiff`).
  ```

- [ ] **Step 2: Commit**
  ```bash
  git add skill-sound/README.md
  git commit -m "docs: add repository readme"
  ```

---

### Task 7: Test and Verify Integration

**Files:**
- Modify: (Verification only, no source files changed)

- [ ] **Step 1: Execute installer**
  Run: `/Users/giorgiolonardo/Development/skills/skill-sound/install.sh`
  Expected: Prints installation success messages.

- [ ] **Step 2: Verify hooks.json generation**
  Run: `cat ~/.gemini/config/plugins/play-sound/hooks.json`
  Expected: The path points to `/Users/giorgiolonardo/.gemini/config/plugins/play-sound/scripts/play-sound.sh`.

- [ ] **Step 3: Verify play-sound is working**
  We will verify manually or trigger an agent turn to confirm that a chime is played on Turn completion and tool calls.
