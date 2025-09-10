# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a collection of Piper Text-to-Speech (TTS) automation scripts designed for macOS. The codebase focuses on converting clipboard text to speech with customizable playback speeds and seamless integration with automation tools like Raycast.

## Architecture & Components

### Core Components

- **`piper-tts_from_clipboard.sh`** - Main TTS script with comprehensive functionality including dependency management, voice model handling, speed controls, and both CLI and Raycast integration
- **`install.sh`** - Automated installer that downloads scripts and sets up the environment
- **`raycast-tts-speed-toggle.sh`** - Raycast wrapper for cycling through playback speeds with visual feedback
- **`raycast-tts-speed-selector.sh`** - Interactive Raycast script for selecting specific TTS speeds with menu interface

### Key Dependencies

The scripts automatically manage these dependencies via Homebrew:
- **Piper TTS** - Neural text-to-speech engine (installed via pipx)
- **ffmpeg/ffplay** - Audio processing and playback
- **pipx** - Python application installer

### Voice Models

- Default: British English (`en_GB-alba-medium`)
- Models stored in `~/.local/share/piper/models/`
- Auto-downloaded from Hugging Face on first run
- Configurable via `PIPER_MODEL` environment variable

## Common Development Commands

### Testing Scripts
```bash
# Test main script with sample text
./piper-tts_from_clipboard.sh "Test message"

# Test with different speeds
./piper-tts_from_clipboard.sh --speed 1.5 "Test message"

# Test clipboard functionality (copy text first)
echo "Test clipboard" | pbcopy && ./piper-tts_from_clipboard.sh

# Enable debug mode for troubleshooting
DEBUG=1 ./piper-tts_from_clipboard.sh "Debug test"
```

### Installation Testing
```bash
# Test installer script
./install.sh

# Test speed toggle (for Raycast integration)
./raycast-tts-speed-toggle.sh

# Test interactive speed selector (for Raycast integration)
./raycast-tts-speed-selector.sh --help
echo "3" | ./raycast-tts-speed-selector.sh  # Select speed option 3 (1.5x)
```

### Voice Model Management
```bash
# List available voice models
ls ~/.local/share/piper/models/*.onnx

# Test with different voice model
PIPER_MODEL=en_US-lessac-medium ./piper-tts_from_clipboard.sh "Test"
```

## Configuration

### Environment Variables
- `PIPER_MODEL` - Override default voice model
- `PIPER_SPEED` - Set default playback speed
- `PIPER_VOICES_DIR` - Custom voice models directory
- `DEBUG` - Enable verbose logging

### Script Configuration (in piper-tts_from_clipboard.sh)
- `DEFAULT_MODEL` - Default voice model selection
- `DEFAULT_SPEED` - Default playback speed multiplier
- `SPEED_MULTIPLIER` - Runtime speed control

## Script Features & Architecture

### Modular Design
The main script uses a function-based architecture with:
- Dependency checking and auto-installation
- Interactive vs. non-interactive mode detection
- Cross-platform path resolution for voice models and binaries
- Comprehensive error handling and logging

### Speed Control System
- Persistent speed state via `~/.piper-tts-speed` file
- Multiple speed control methods: CLI args, environment variables, interactive selection
- Speed cycling for automation tools

### Raycast Integration
- Proper metadata headers for Raycast script commands
- Compact mode output suitable for notification display
- Environment detection to handle non-interactive execution

### Error Handling
- Graceful degradation when dependencies are missing
- Clear error messages with suggested solutions
- Temporary file cleanup via trap handlers
- Input validation (text length limits, empty clipboard handling)

## File Structure & Data Flow

```
scripts/
├── piper-tts_from_clipboard.sh    # Main TTS engine
├── raycast-tts-speed-toggle.sh    # Raycast speed cycling wrapper
├── raycast-tts-speed-selector.sh  # Raycast interactive speed selection
├── install.sh                     # Automated setup
└── README.md                      # User documentation

Data Locations:
~/.local/share/piper/models/        # Voice models
~/.piper-tts-speed                  # Speed preference state
/tmp/piper_clip_*.wav               # Temporary audio files
```

## Development Notes

### macOS-Specific Considerations
- Uses `pbpaste` for clipboard access
- Homebrew for dependency management
- Audio playback via `ffplay`
- File system permissions for model storage

### Audio Pipeline
1. Text input (clipboard or argument)
2. Piper TTS synthesis → WAV file
3. Speed adjustment via ffmpeg (if needed)
4. Playback via ffplay
5. Cleanup of temporary files

### Integration Points
- Designed for Raycast script commands with metadata headers
- Terminal-friendly with interactive dependency installation
- Environment variable configuration for automation
- Symlink support for PATH integration

## Key Patterns

### Robust Path Resolution
Scripts use multiple fallback locations for finding binaries and voice models, ensuring compatibility across different installation methods.

### Environment Detection
Scripts automatically detect whether they're running in interactive vs. automation contexts and adjust behavior accordingly.

### State Management
Speed preferences persist across sessions using simple file-based storage, enabling consistent user experience in automation scenarios.
