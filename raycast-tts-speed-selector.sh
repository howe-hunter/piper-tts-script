#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title TTS Speed Selector
# @raycast.mode fullOutput
# @raycast.packageName Text to Speech
# @raycast.icon ⚡

# Documentation:
# @raycast.description Set TTS playback speed and speak clipboard content
# @raycast.author Hunter Howe
# @raycast.authorURL https://github.com/howe-hunter

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

# Speed options and their descriptions
SPEEDS=("0.8" "1.0" "1.5" "2.0" "2.5" "3.0")
SPEED_NAMES=("0.8x - Slow & Clear" "1.0x - Normal Speed" "1.5x - Comfortable Fast" "2.0x - Double Speed" "2.5x - Very Fast" "3.0x - Maximum Speed")
SPEED_ICONS=("🐌" "🚶" "🏃" "🏎️" "⚡" "🚀")

# Function to get current speed index
get_current_speed_index() {
    local current_index=3  # Default to 2.0x (index 3)
    if [[ -f "$SPEED_FILE" ]]; then
        current_index=$(cat "$SPEED_FILE" 2>/dev/null || echo "3")
        # Validate index is within bounds
        if [[ $current_index -lt 0 || $current_index -ge ${#SPEEDS[@]} ]]; then
            current_index=3
        fi
    fi
    echo "$current_index"
}

# Function to set speed and update persistent storage
set_speed() {
    local index=$1
    echo "$index" > "$SPEED_FILE"
    echo "✅ Speed set to: ${SPEED_ICONS[$index]} ${SPEED_NAMES[$index]}"
}

# Function to display current speed
show_current_speed() {
    local current_index=$(get_current_speed_index)
    echo "🎵 Current TTS Speed: ${SPEED_ICONS[$current_index]} ${SPEED_NAMES[$current_index]}"
    echo ""
}

# Function to display menu and handle selection
show_speed_menu() {
    local current_index=$(get_current_speed_index)
    
    echo "🎵 Select TTS Playback Speed:"
    echo ""
    
    for i in "${!SPEEDS[@]}"; do
        local marker="  "
        if [[ $i -eq $current_index ]]; then
            marker="▶ "  # Current selection marker
        fi
        echo "${marker}$((i+1))) ${SPEED_ICONS[$i]} ${SPEED_NAMES[$i]}"
    done
    
    echo ""
    echo "Enter your choice (1-${#SPEEDS[@]}), or press Enter to keep current speed:"
}

# Main interactive logic
main() {
    show_current_speed
    show_speed_menu
    
    # Read user input (Raycast will handle this)
    read -r choice
    
    # Handle empty input (keep current speed)
    if [[ -z "$choice" ]]; then
        local current_index=$(get_current_speed_index)
        echo "🔄 Keeping current speed: ${SPEED_ICONS[$current_index]} ${SPEED_NAMES[$current_index]}"
    else
        # Validate and process choice
        if [[ "$choice" =~ ^[1-6]$ ]]; then
            local index=$((choice - 1))
            set_speed "$index"
        else
            echo "❌ Invalid choice. Please enter a number between 1 and ${#SPEEDS[@]}."
            exit 1
        fi
    fi
    
    echo ""
    echo "🔊 Speaking clipboard content..."
    
    # Check if clipboard has content
    local clipboard_content
    clipboard_content=$(pbpaste 2>/dev/null)
    
    if [[ -z "$clipboard_content" ]]; then
        echo "⚠️  Clipboard is empty. Please copy some text and try again."
        exit 1
    fi
    
    # Show preview of clipboard content (first 100 characters)
    local preview="${clipboard_content:0:100}"
    if [[ ${#clipboard_content} -gt 100 ]]; then
        preview="${preview}..."
    fi
    echo "📋 Speaking: \"$preview\""
    echo ""
    
    # Execute main TTS script
    exec "$MAIN_SCRIPT"
}

# Add help option
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    cat << EOF
🎵 Raycast TTS Speed Selector

Interactive script for selecting TTS playback speed and speaking clipboard content.

USAGE:
    Run this script from Raycast to:
    1. View current speed setting
    2. Select a new speed (optional)
    3. Speak clipboard content at the selected speed

SPEED OPTIONS:
    🐌 0.8x - Slow & Clear      (perfect for learning)
    🚶 1.0x - Normal Speed      (standard speech rate)
    🏃 1.5x - Comfortable Fast  (efficient listening)
    🏎️  2.0x - Double Speed     (default setting)
    ⚡ 2.5x - Very Fast        (for experienced users)
    🚀 3.0x - Maximum Speed    (ultra-fast)

RAYCAST SETUP:
    1. Add this script as a Script Command in Raycast
    2. Set mode to "fullOutput" for interactive input
    3. Use keyword like "tts-speed" or "speed"

FEATURES:
    - Interactive speed selection with visual indicators
    - Persistent speed settings across sessions
    - Clipboard content preview before speaking
    - Current speed indicator with emoji icons
    - Graceful handling of empty clipboard

EOF
    exit 0
fi

# Run main function
main
