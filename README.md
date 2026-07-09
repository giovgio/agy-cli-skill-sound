# Antigravity CLI Sound Notifications (`play-sound`)

A global plugin and skill for the Google Antigravity CLI (`agy`) that chimes when your agent needs input or approval on macOS.

Offer me a coffee if this skill is useful for you: https://buymeacoffee.com/mrtobor

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

## Support

If this skill is useful for you, feel free to buy me a coffee!
[Buy Me a Coffee ☕](https://buymeacoffee.com/mrtobor)
