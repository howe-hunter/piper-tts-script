#!/bin/bash

# =============================================================================
# Raycast TTS Speed Toggle
# =============================================================================
# Raycast-optimized script for cycling through speech speeds
#
# Raycast Parameters:
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title TTS Speed Toggle
# @raycast.mode compact
# @raycast.icon 🔄
# @raycast.description Cycle through TTS playback speeds and speak clipboard
# @raycast.packageName Text-to-Speech

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT="$SCRIPT_DIR/piper-tts_from_clipboard.sh"
SPEED_FILE="$HOME/.piper-tts-speed"

# Check if main script exists
if [ ! -f "$MAIN_SCRIPT" ]; then
    echo "❌ Main TTS script not found at: $MAIN_SCRIPT"
    echo "Please ensure piper-tts_from_clipboard.sh is in the same directory"
    exit 1
fi

# Speed cycling with visual feedback
SPEEDS=("1.0" "1.5" "2.0" "2.5" "3.0")
SPEED_NAMES=("Normal" "Comfortable" "Double" "Very Fast" "Maximum")
SPEED_ICONS=("🚶" "🏃" "🏎️" "⚡" "🚀")

# Get current speed index, default to 2 (2.0x)
current_index=2
if [[ -f "$SPEED_FILE" ]]; then
    current_index=$(cat "$SPEED_FILE" 2>/dev/null || echo "2")
    # Validate index is within bounds
    if [[ $current_index -lt 0 || $current_index -ge ${#SPEEDS[@]} ]]; then
        current_index=2
    fi
fi

# Cycle to next speed
current_index=$(( (current_index + 1) % ${#SPEEDS[@]} ))

# Save new index
echo "$current_index" > "$SPEED_FILE"

# Show speed change with icon
echo "🔄 Speed: ${SPEED_ICONS[$current_index]} ${SPEEDS[$current_index]}x (${SPEED_NAMES[$current_index]})"

# Check clipboard content
clipboard_content=$(pbpaste 2>/dev/null)
if [[ -z "$clipboard_content" ]]; then
    echo "⚠️  Clipboard is empty. Please copy some text and try again."
    exit 1
fi

# Execute main TTS script
exec "$MAIN_SCRIPT"
