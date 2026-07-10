---
name: play-sound
description: Use when you want to enable audible sound alerts in agy on macOS for turn completions or user approval prompts.
---

# Play Sound Skill

## Overview
Plays sound notifications on macOS to alert the user when agy requires input or action.

## Triggers
1. **Turn completion (`Stop` event)**: A soft Tink sound chimes when the execution loop terminates, indicating it is waiting for your next text input.
2. **User approval (`PreToolUse` event)**: A Glass sound chimes when a tool (e.g. `run_command`, `ask_permission`, `ask_question`) is halted and waiting for user approval.
