# Design Spec: play-sound Antigravity Plugin and Skill

## Overview
This specification details the structure, implementation, and installation process for a Google Antigravity (`agy`) plugin that plays sound notifications on macOS. Sounds are triggered when:
1. The agent's execution turn completes and it waits for text input (`Stop` hook).
2. The agent is about to execute a tool that requires user approval, such as `run_command`, `ask_permission`, or `ask_question` (`PreToolUse` hook).

## Directory Structure
The project inside `/Users/giorgiolonardo/Development/skills/skill-sound` is organized as follows:
```
.
├── README.md               # User documentation for GitHub
├── plugin.json             # Antigravity plugin manifest
├── hooks.json              # Hook event mappings
├── install.sh              # Installation script for global activation
├── scripts/
│   └── play-sound.sh       # Sound playback wrapper using afplay
└── skills/
    └── play-sound/
        └── SKILL.md        # The Antigravity skill reference
```

## Specifications

### 1. `plugin.json`
Declares the metadata of the plugin:
```json
{
  "name": "play-sound",
  "version": "1.0.0",
  "description": "Emits sound notifications when agy finishes a turn or requires approval.",
  "author": "giorgiolonardo"
}
```

### 2. `hooks.json`
Maps Antigravity lifecycle events to the audio playback script:
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
*Note: During installation, `HOOK_PLAY_COMMAND` is dynamically replaced with the absolute path to the installed `play-sound.sh` script (e.g. `/Users/giorgiolonardo/.gemini/config/plugins/play-sound/scripts/play-sound.sh`).*

### 3. `scripts/play-sound.sh`
A robust macOS sound-playing shell script.
* Uses the native `/usr/bin/afplay` utility.
* Uses the `/System/Library/Sounds/Glass.aiff` system sound.
* Executes the playback asynchronously in the background (`&`) to prevent blocking the Antigravity execution loop.

### 4. `skills/play-sound/SKILL.md`
Audible alerts configuration skill. Defines how other agents know this capability exists.
```markdown
---
name: play-sound
description: Use when you want to enable audible sound alerts in agy on macOS for turn completions or user approval prompts.
---

# Play Sound

This skill enables agy to play a chime when:
1. The execution loop finishes and waits for user input.
2. A tool (e.g. `run_command`) requires explicit user approval.
```

### 5. `install.sh`
Automates copying the plugin and skill to the user's config directory:
* Resolves target paths:
  * Plugin destination: `~/.gemini/config/plugins/play-sound/`
  * Skill destination: `~/.gemini/config/skills/play-sound/`
* Replaces the placeholder `HOOK_PLAY_COMMAND` in `hooks.json` with the correct absolute path.
* Ensures scripts are executable.

## Testing & Verification Plan
1. Run `install.sh` locally to install the plugin and skill.
2. Run a command in `agy` that triggers a tool requiring approval (e.g., `git status` or a simple mock tool call).
3. Verify that the sound plays immediately when the approval prompt is shown.
4. Verify that the sound plays when the turn completes.
