# Antigravity CLI Sound Notifications

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

Alternatively, you can edit the script directly at `~/.gemini/config/plugins/play-sound/scripts/play-sound.sh` and change the default file paths.

## Support

If this skill is useful for you, feel free to buy me a coffee!
[Buy Me a Coffee ☕](https://buymeacoffee.com/mrtobor)
