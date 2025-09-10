# Piper TTS Script

> AI-assisted development using [Perplexity AI](https://perplexity.ai) and [Warp Terminal](https://warp.dev)

Converts text to high-quality speech using [Piper TTS](https://github.com/rhasspy/piper). Works from Terminal or Raycast with automatic setup.

## What This Does
- Reads text from your clipboard and speaks it aloud
- Automatically installs all required software (ffmpeg, piper-tts)
- Works in Terminal, Raycast, and other automation tools
- Supports multiple languages and voice models
- Plays audio at 2x speed by default (customizable)
- Handles both clipboard text and direct text input

## Installation

### Quick Setup (Recommended)
1. Open Terminal (find it in Applications > Utilities)
2. Copy and paste this command:
```bash
curl -fsSL https://raw.githubusercontent.com/howe-hunter/piper-tts-script/main/install.sh | bash
```
3. Press Enter and wait for installation to complete
4. The script will be installed to `~/piper-tts-script/`

### Manual Installation
If you prefer to download manually:

1. Download the script file:
```bash
curl -O https://raw.githubusercontent.com/howe-hunter/piper-tts-script/main/piper-tts_from_clipboard.sh
```

2. Make it executable:
```bash
chmod +x piper-tts_from_clipboard.sh
```

3. Run it once to install dependencies:
```bash
./piper-tts_from_clipboard.sh
```

**Note**: The first run will automatically install ffmpeg and piper-tts. This requires Homebrew, which will also be installed if needed.

## How to Use

### From Terminal
Open Terminal and run the script:

```bash
# Speak whatever text is currently in your clipboard (2x speed default)
./piper-tts_from_clipboard.sh

# Speak specific text directly
./piper-tts_from_clipboard.sh "Hello world, this is a test"

# Control playback speed
./piper-tts_from_clipboard.sh --speed 1.0      # Normal speed
./piper-tts_from_clipboard.sh -s 3.0          # 3x speed (clipboard)
./piper-tts_from_clipboard.sh -s 1.5 "Hello"  # 1.5x speed with text

# Show all available options
./piper-tts_from_clipboard.sh --help
```

**Tip**: Copy any text to your clipboard (Cmd+C), then run the script to hear it spoken aloud.

### Raycast Integration
Raycast is a productivity app that lets you run scripts with keyboard shortcuts.

1. **Install Raycast** (if you haven't already): Download from [raycast.com](https://raycast.com)

2. **Add the Script**:
   - Open Raycast (Cmd+Space)
   - Type "Create Script Command" and press Enter
   - Or go to Raycast → Extensions → Script Commands → Add Script Command

3. **Configure the Script**:
   - **Title**: "Speak Clipboard" (or whatever you prefer)
   - **Script**: Enter the full path to your script file
     - If you used quick setup: `~/piper-tts-script/piper-tts_from_clipboard.sh`
     - If manual: `/path/to/your/piper-tts_from_clipboard.sh`
   - **Shell**: `bash`
   - **Mode**: `compact`
   - **Package Name**: `TTS` or `Text to Speech`
   - **Icon**: Choose a microphone or speaker emoji
   - **Keyword**: `tts`, `speak`, or `read` (whatever you want to type to trigger it)

4. **Use It**:
   - Copy any text (Cmd+C)
   - Open Raycast (Cmd+Space)
   - Type your keyword (e.g., "tts")
   - Press Enter to hear your text spoken

## Customization

### Change Voice Model
The script uses British English by default. To use a different voice:

```bash
# Use American English (if you have the model)
export PIPER_MODEL="en_US-lessac-medium"
./piper-tts_from_clipboard.sh

# Use German (if you have the model)
export PIPER_MODEL="de_DE-thorsten-medium"
./piper-tts_from_clipboard.sh
```

### Change Speaking Speed
Multiple ways to control playback speed:

**Command line (easiest)**:
```bash
./piper-tts_from_clipboard.sh --speed 1.0     # Normal speed
./piper-tts_from_clipboard.sh -s 1.5          # 1.5x speed
```

**Environment variable**:
```bash
export PIPER_SPEED=1.5
./piper-tts_from_clipboard.sh                 # Uses 1.5x speed
```

**Edit script file** (permanent change):
```bash
DEFAULT_SPEED="1.0"  # Change default from 2.0 to 1.0
```

### Custom Voice Directory
If you want to store voice models in a specific location:
```bash
export PIPER_VOICES_DIR="/Users/yourname/MyVoices"
```

## Voice Models and Languages

The script comes with British English voice by default. You can add more languages and voices.

### Available Languages
- **English**: US, UK, Australian accents
- **European**: French, German, Spanish, Italian, Dutch, Portuguese
- **Other**: Russian, Arabic, and many more

### Adding New Voices
1. **Browse available voices**: Visit [Hugging Face Piper Voices](https://huggingface.co/rhasspy/piper-voices)

2. **Download a voice model**: 
```bash
# Go to the voice models directory
cd ~/.local/share/piper/models

# Example: Download American English voice
curl -L "https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx" -o en_US-lessac-medium.onnx
curl -L "https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json" -o en_US-lessac-medium.onnx.json
```

3. **Use the new voice**:
```bash
PIPER_MODEL=en_US-lessac-medium ./piper-tts_from_clipboard.sh
```

### Popular Voice Models
- `en_US-lessac-medium` - American English (clear, professional)
- `en_GB-alba-medium` - British English (default)
- `fr_FR-siwis-medium` - French
- `de_DE-thorsten-medium` - German
- `es_ES-davefx-medium` - Spanish

## Troubleshooting

### If Something Goes Wrong

**Enable debug mode** to see detailed information:
```bash
DEBUG=1 ./piper-tts_from_clipboard.sh
```

### Common Issues and Solutions

**"Command not found" or "Dependencies missing"**
- Solution: Run the script once in Terminal to auto-install everything
- The script will install Homebrew, ffmpeg, and piper-tts automatically

**"Voice model not found"**
- Check what models you have: `ls ~/.local/share/piper/models/`
- The script will try to download the default model on first run
- If that fails, manually download a model (see Voice Models section above)

**"No audio" or "Audio not playing"**
- Test your audio: `ffplay /System/Library/Sounds/Ping.aiff`
- Check your volume and audio output device
- Try running the script from Terminal first to see error messages

**Raycast not working**
- Make sure you're using the full path to the script file
- Example: `/Users/yourname/piper-tts-script/piper-tts_from_clipboard.sh`
- Try running the script in Terminal first to ensure it works
- Check that the script file has execute permissions: `chmod +x scriptname.sh`

**Script runs but no sound**
- Your clipboard might be empty - copy some text first
- The text might be too long - try with shorter text
- Check if other apps are using your audio

## System Requirements
- **macOS**: Version 11 (Big Sur) or newer
- **Disk Space**: About 50MB for the software and voice models  
- **Internet**: Required for initial setup and downloading voice models
- **Audio**: Working speakers or headphones

## Technical Details

### File Locations
- **Voice models**: `~/.local/share/piper/models/`
- **Piper binary**: `~/.local/bin/piper` (installed via pipx)
- **Temporary audio files**: `/tmp/piper_clip_*.wav` (auto-cleaned)

### What Gets Installed
When you first run the script, it automatically installs:
- **Homebrew**: macOS package manager (if not already installed)
- **ffmpeg**: Audio processing software
- **pipx**: Python application installer  
- **piper-tts**: The text-to-speech engine

## Credits and Acknowledgments
- **[Piper TTS](https://github.com/rhasspy/piper)** - The excellent neural text-to-speech system that powers this script
- **[Rhasspy Community](https://github.com/rhasspy)** - For creating and maintaining the voice models
- **[Perplexity AI](https://perplexity.ai)** - AI research assistance during development
- **[Warp Terminal](https://warp.dev)** - AI-powered terminal used for collaborative development

This project demonstrates human-AI collaboration in software development, combining human creativity with AI assistance to create a robust, user-friendly tool.
