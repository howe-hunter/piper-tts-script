#!/bin/bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Piper TTS Clipboard
# @raycast.mode compact
# @raycast.icon 🔊
# Documentation:
# @raycast.description Speak clipboard with Piper TTS at 2x speed
# @raycast.author hunter howe

# =============================================================================
# CONFIGURATION - Customize these settings
# =============================================================================

# Default voice model (can be overridden by environment variable PIPER_MODEL)
DEFAULT_MODEL="en_GB-alba-medium"  # British English model

# Speed multiplier for audio playback (1.0 = normal, 2.0 = double speed)
SPEED_MULTIPLIER="2.0"

# Debug mode (set DEBUG=1 to enable verbose output)
DEBUG="${DEBUG:-0}"

# Temporary file locations
TMPWAV="/tmp/piper_clip_$$.wav"  # Use process ID to avoid conflicts
FASTWAV="/tmp/piper_clip_fast_$$.wav"

# =============================================================================
# FUNCTIONS
# =============================================================================

# Print colored output
log_info() {
    echo "ℹ️  $1" >&2
}

log_error() {
    echo "❌ Error: $1" >&2
}

log_success() {
    echo "✅ $1" >&2
}

log_debug() {
    if [[ "$DEBUG" == "1" ]]; then
        echo "🔍 DEBUG: $1" >&2
    fi
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Find piper installation
find_piper() {
    local piper_locations=(
        "$HOME/.local/bin/piper"           # pipx installation
        "/opt/homebrew/bin/piper"          # Homebrew ARM Mac
        "/usr/local/bin/piper"             # Homebrew Intel Mac
        "$(which piper 2>/dev/null)"       # In PATH
    )
    
    for location in "${piper_locations[@]}"; do
        if [ -n "$location" ] && [ -f "$location" ]; then
            echo "$location"
            return 0
        fi
    done
    
    return 1
}

# Find voice model directory
find_voice_dir() {
    local voice_dirs=(
        "$HOME/Desktop/piper-tts-script/voices"  # Desktop installation voices directory
        "$(pwd)"                           # Current directory
        "$HOME/.local/share/piper/models"  # Default piper models directory
        "$HOME/Documents/piper-voices"     # Common user location
        "$HOME/piper-voices"               # Alternative user location
        "$PIPER_VOICES_DIR"                # Environment variable
    )
    
    for dir in "${voice_dirs[@]}"; do
        if [ -n "$dir" ] && [ -d "$dir" ]; then
            # Check if the directory contains .onnx model files
            if ls "$dir"/*.onnx >/dev/null 2>&1; then
                echo "$dir"
                return 0
            fi
        fi
    done
    
    return 1
}

# Install missing dependencies
install_dependencies() {
    log_info "Checking dependencies..."
    
    # Check for Homebrew (macOS package manager)
    if ! command_exists brew; then
        log_error "Homebrew not found. Please install Homebrew first:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" >&2
        exit 1
    fi
    
    # Check and install ffmpeg
    if ! command_exists ffmpeg; then
        log_info "Installing ffmpeg..."
        brew install ffmpeg || {
            log_error "Failed to install ffmpeg"
            exit 1
        }
    fi
    
    # Check and install pipx
    if ! command_exists pipx; then
        log_info "Installing pipx..."
        brew install pipx || {
            log_error "Failed to install pipx"
            exit 1
        }
    fi
    
    # Check and install piper-tts
    if ! find_piper >/dev/null; then
        log_info "Installing piper-tts..."
        pipx install piper-tts || {
            log_error "Failed to install piper-tts"
            exit 1
        }
    fi
    
    log_success "All dependencies are installed"
}

# Download default voice model if needed
download_default_model() {
    local model_name="$1"
    local voice_dir="$2"
    
    if [ ! -f "$voice_dir/${model_name}.onnx" ]; then
        log_info "Downloading default voice model: $model_name"
        
        # Create voice directory if it doesn't exist
        mkdir -p "$voice_dir"
        
        # Download model files from Hugging Face
        # Map model names to their download URLs
        local base_url
        local source_name
        
        case "$model_name" in
            "en_GB-alba-medium")
                base_url="https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/alba/medium"
                source_name="en_GB-alba-medium"
                ;;
            "en_US-lessac-medium")
                base_url="https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium"
                source_name="en_US-lessac-medium"
                ;;
            *)
                log_error "Unknown model: $model_name. Please download it manually."
                return 1
                ;;
        esac
        
        curl -L "${base_url}/${source_name}.onnx" -o "$voice_dir/${model_name}.onnx" || {
            log_error "Failed to download voice model"
            return 1
        }
        
        curl -L "${base_url}/${source_name}.onnx.json" -o "$voice_dir/${model_name}.onnx.json" || {
            log_error "Failed to download voice model config"
            return 1
        }
        
        log_success "Voice model downloaded successfully"
    fi
}

# =============================================================================
# HELP AND USAGE
# =============================================================================

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    cat << EOF
🔊 Piper TTS Clipboard Script

Converts text to speech using Piper TTS with customizable speed.

USAGE:
    $0 [text]                    # Speak provided text
    $0                           # Speak clipboard content
    $0 --help                    # Show this help

CONFIGURATION:
    PIPER_MODEL=model_name       # Override voice model
    PIPER_VOICES_DIR=path        # Custom voice models directory
    
EXAMPLES:
    $0 "Hello world"             # Speak "Hello world"
    echo "Test" | pbcopy && $0   # Copy text and speak it
    PIPER_MODEL=en_GB-alba-medium $0  # Use British English voice

INSTALLATION:
    Run this script in Terminal to auto-install all dependencies.
    
REQUIREMENTS:
    - macOS
    - Homebrew (auto-installed if missing)
    - ffmpeg (auto-installed via Homebrew)
    - piper-tts (auto-installed via pipx)
    
VOICE MODELS:
    Voice models are automatically downloaded to ~/.local/share/piper/models/
    You can download additional models from: https://huggingface.co/rhasspy/piper-voices

EOF
    exit 0
fi

# =============================================================================
# DEPENDENCY CHECKS AND SETUP
# =============================================================================

# Check for macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS only"
    exit 1
fi

# Check for pbpaste (should be available on macOS)
if ! command_exists pbpaste; then
    log_error "pbpaste not found. This script requires macOS."
    exit 1
fi

# Detect if we're running in Raycast or other automation tool
IS_INTERACTIVE=false
log_debug "Environment detection: stdin_tty=[[ -t 0 ]]=$([[ -t 0 ]] && echo true || echo false), stdout_tty=[[ -t 1 ]]=$([[ -t 1 ]] && echo true || echo false), TERM=$TERM, PWD=$PWD"
if [[ -t 0 ]] && [[ -t 1 ]] && [[ -z "$RAYCAST" ]] && [[ -z "$RAYCAST_SCRIPT" ]] && [[ "$TERM" != "dumb" ]]; then
    IS_INTERACTIVE=true
fi
log_debug "Interactive mode: $IS_INTERACTIVE"

# Install missing dependencies if in interactive mode
if [[ "$IS_INTERACTIVE" == "true" ]]; then
    install_dependencies
fi

# Find piper installation
PIPER_CMD=$(find_piper)
log_debug "Found piper at: $PIPER_CMD"
if [ -z "$PIPER_CMD" ]; then
    log_error "Piper TTS not found. Please install it with: pipx install piper-tts"
    log_info "Or run this script in a terminal to auto-install dependencies"
    exit 1
fi

# Determine voice model to use
MODEL="${PIPER_MODEL:-$DEFAULT_MODEL}"
log_debug "Using voice model: $MODEL"

# Find voice directory
VOICE_DIR=$(find_voice_dir)
log_debug "Found voice directory: $VOICE_DIR"
if [ -z "$VOICE_DIR" ]; then
    # Create default voice directory on Desktop
    VOICE_DIR="$HOME/Desktop/piper-tts-script/voices"
    mkdir -p "$VOICE_DIR"
    
    # Download default model if we're in interactive mode
    if [[ "$IS_INTERACTIVE" == "true" ]]; then
        download_default_model "$MODEL" "$VOICE_DIR"
    else
        log_error "No voice models found. Please download a voice model or run this script in a terminal to auto-download."
        log_info "Voice models should be placed in: $VOICE_DIR"
        log_info "Available models in current directory: $(ls -1 *.onnx 2>/dev/null | sed 's/\.onnx$//' | tr '\n' ', ' | sed 's/,$//' || echo 'none')"
        exit 1
    fi
fi

# Verify the specific model exists
if [ ! -f "$VOICE_DIR/${MODEL}.onnx" ]; then
    log_error "Voice model '${MODEL}.onnx' not found in $VOICE_DIR"
    log_info "Available models:"
    ls -1 "$VOICE_DIR"/*.onnx 2>/dev/null | sed 's/.*\///; s/\.onnx$//' | sed 's/^/  - /' >&2 || echo "  (none found)" >&2
    log_info "You can set a different model with: export PIPER_MODEL=model_name"
    exit 1
fi

# Verify other dependencies
for dep in ffmpeg ffplay; do
    if ! command_exists "$dep"; then
        log_error "$dep not found. Please install it with: brew install ffmpeg"
        exit 1
    fi
done

# =============================================================================
# CLEANUP FUNCTION
# =============================================================================

# Cleanup function to remove temporary files
cleanup() {
    rm -f "$TMPWAV" "$FASTWAV" 2>/dev/null
}

# Set trap to cleanup on exit
trap cleanup EXIT INT TERM

# Remove any existing temp files from previous runs
rm -f /tmp/piper_clip*.wav 2>/dev/null

# =============================================================================
# MAIN SCRIPT LOGIC
# =============================================================================

# Get text input
if [ -n "$1" ]; then
    TEXT="$1"
    log_info "Using provided text: ${TEXT:0:50}..."
else
    TEXT="$(pbpaste)"
    if [ -n "$TEXT" ]; then
        log_info "Using clipboard text: ${TEXT:0:50}..."
    fi
fi

# Validate input
if [ -z "$TEXT" ]; then
    log_error "No text provided. Either provide text as an argument or copy text to clipboard."
    echo "Usage: $0 [text-to-speak]" >&2
    exit 1
fi

# Limit text length to prevent extremely long audio
if [ ${#TEXT} -gt 1000 ]; then
    log_error "Text is too long (${#TEXT} characters). Maximum supported length is 1000 characters."
    exit 1
fi

# Generate TTS audio
log_info "Generating speech audio..."
if ! "$PIPER_CMD" -m "$MODEL" --data-dir "$VOICE_DIR" -f "$TMPWAV" -- "$TEXT" 2>/dev/null; then
    log_error "Failed to generate speech audio. Check if voice model '$MODEL' is valid."
    exit 1
fi

# Verify audio file was created
if [ ! -f "$TMPWAV" ] || [ ! -s "$TMPWAV" ]; then
    log_error "No audio generated. The text might be empty or invalid."
    exit 1
fi

# Apply speed adjustment if not 1.0
if [ "$SPEED_MULTIPLIER" != "1.0" ]; then
    log_info "Adjusting playback speed to ${SPEED_MULTIPLIER}x..."
    if ! ffmpeg -y -i "$TMPWAV" -filter:a "atempo=$SPEED_MULTIPLIER" "$FASTWAV" 2>/dev/null; then
        log_error "Failed to adjust audio speed"
        exit 1
    fi
    FINAL_AUDIO="$FASTWAV"
else
    FINAL_AUDIO="$TMPWAV"
fi

# Play the audio
log_success "Playing audio..."
if ! ffplay -autoexit -nodisp "$FINAL_AUDIO" 2>/dev/null; then
    log_error "Failed to play audio. Make sure your audio output is working."
    exit 1
fi

log_success "Text-to-speech completed successfully!"
