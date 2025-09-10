# Piper TTS Script

> AI-assisted development using [Perplexity AI](https://perplexity.ai) and [Warp Terminal](https://warp.dev)

Text-to-speech script using [Piper TTS](https://github.com/rhasspy/piper) with auto-installation and Raycast integration.

## Features
- Auto-installs dependencies (ffmpeg, piper-tts)
- Multi-environment support (Terminal, Raycast)
- Voice model auto-detection
- Configurable playback speed (default 2x)
- Clipboard or text input

## Installation

### Auto-install
```bash
curl -fsSL https://raw.githubusercontent.com/howe-hunter/piper-tts-script/main/install.sh | bash
```

### Manual
```bash
# Download script
wget https://raw.githubusercontent.com/howe-hunter/piper-tts-script/main/piper-tts_from_clipboard.sh
chmod +x piper-tts_from_clipboard.sh

# Run once to install dependencies
./piper-tts_from_clipboard.sh
```

## Usage

### Terminal
```bash
./piper-tts_from_clipboard.sh                    # Speak clipboard
./piper-tts_from_clipboard.sh "Hello world"      # Speak text
./piper-tts_from_clipboard.sh --help             # Show help
```

### Raycast Integration
1. **Add Script Command**: Raycast → Extensions → Script Commands → Add Script Command
2. **Configure**:
   - **Script**: `/path/to/piper-tts_from_clipboard.sh`
   - **Shell**: `bash`
   - **Mode**: `compact`
   - **Package Name**: `TTS`
3. **Set Icon**: Choose microphone/speaker emoji
4. **Keyword**: `tts` or `speak`

### Configuration
```bash
# Environment variables
export PIPER_MODEL="en_GB-alba-medium"           # Voice model
export PIPER_VOICES_DIR="/path/to/voices"        # Voice directory

# Speed (edit SPEED_MULTIPLIER in script)
SPEED_MULTIPLIER="2.0"  # 2x speed (default)
```

## Voice Models

Default: `en_GB-alba-medium` (British English)

### Download Additional Models
```bash
# Download to ~/.local/share/piper/models/
cd ~/.local/share/piper/models

# British English
curl -L https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/alba/medium/en_GB-alba-medium.onnx -o en_GB-alba-medium.onnx
curl -L https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/alba/medium/en_GB-alba-medium.onnx.json -o en_GB-alba-medium.onnx.json

# Use different model
PIPER_MODEL=en_GB-alba-medium ./piper-tts_from_clipboard.sh
```

More models: [Hugging Face](https://huggingface.co/rhasspy/piper-voices)

## Troubleshooting

### Debug Mode
```bash
DEBUG=1 ./piper-tts_from_clipboard.sh
```

### Common Issues
- **Dependencies missing**: Run script in Terminal first to auto-install
- **Voice model not found**: Check `ls ~/.local/share/piper/models/`
- **Audio issues**: Test with `ffplay /System/Library/Sounds/Ping.aiff`
- **Raycast issues**: Verify script path is absolute

## Requirements
- macOS 11+
- ~50MB disk space
- Network access (initial setup)

## File Locations
- Voice models: `~/.local/share/piper/models/`
- Piper binary: `~/.local/bin/piper`
- Temp files: `/tmp/piper_clip_*.wav`

## Credits
- **[Piper TTS](https://github.com/rhasspy/piper)** - Core TTS engine
- **[Perplexity AI](https://perplexity.ai)** - Research assistance  
- **[Warp Terminal](https://warp.dev)** - AI development environment
