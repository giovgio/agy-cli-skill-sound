#!/usr/bin/env python3
import sys
import os
import json

def get_last_active_conversation_id():
    history_path = os.path.expanduser('~/.gemini/antigravity-cli/history.jsonl')
    if not os.path.exists(history_path):
        return None
    try:
        # Read the file from the end to find the last line with conversationId
        with open(history_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            for line in reversed(lines):
                try:
                    data = json.loads(line)
                    if 'conversationId' in data:
                        return data['conversationId']
                except Exception:
                    continue
    except Exception:
        pass
    return None

def is_command_allowed(command_line, allow_rules):
    cmd_tokens = command_line.strip().split()
    if not cmd_tokens:
        return False
    for rule in allow_rules:
        if rule.startswith("command(") and rule.endswith(")"):
            rule_content = rule[8:-1]
            rule_tokens = rule_content.strip().split()
            if len(cmd_tokens) >= len(rule_tokens):
                if cmd_tokens[:len(rule_tokens)] == rule_tokens:
                    return True
    return False

def check_should_play(event_type, payload_str):
    try:
        payload = json.loads(payload_str)
    except Exception:
        return True # Default to playing if JSON is invalid

    conv_id = payload.get('conversationId')
    if not conv_id:
        return True

    # 1. Verify if this is the active main conversation
    main_conv_id = get_last_active_conversation_id()
    if main_conv_id and conv_id != main_conv_id:
        # Not the main conversation, do not play sound
        return False

    # 2. Check if the tool call is auto-approved
    if event_type == 'approval':
        tool_call = payload.get('toolCall', {})
        tool_name = tool_call.get('name')
        if tool_name == 'run_command':
            args = tool_call.get('args', {})
            command_line = args.get('CommandLine')
            if command_line:
                settings_path = os.path.expanduser('~/.gemini/antigravity-cli/settings.json')
                if os.path.exists(settings_path):
                    try:
                        with open(settings_path, 'r', encoding='utf-8') as f:
                            settings = json.load(f)
                            allow_rules = settings.get('permissions', {}).get('allow', [])
                            if is_command_allowed(command_line, allow_rules):
                                # Command is allowed/auto-approved, do not play sound
                                return False
                    except Exception:
                        pass

    return True

def main():
    event_type = sys.argv[1] if len(sys.argv) > 1 else 'default'
    payload_str = sys.stdin.read()
    
    if check_should_play(event_type, payload_str):
        sys.exit(0) # Play sound
    else:
        sys.exit(1) # Do not play sound

if __name__ == '__main__':
    main()
