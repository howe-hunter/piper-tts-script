# Warp Terminal Integration Guide

> **Warp**: The AI-powered terminal that supercharges your development workflow

This guide shows you how to get the most out of the Piper TTS script when using [Warp Terminal](https://warp.dev), including AI-assisted workflows and terminal optimizations.

## Why Warp + Piper TTS?

Warp's AI capabilities make it perfect for working with this TTS script:
- **AI Command Suggestions**: Get intelligent command completions for TTS workflows
- **Workflow Blocks**: Save and reuse common TTS command patterns
- **Smart History**: Easily find and repeat previous TTS commands
- **Terminal Sharing**: Share TTS workflows with your team

## Quick Setup in Warp

### 1. Install the Script
Open Warp and run the quick installer:

```bash
curl -fsSL https://raw.githubusercontent.com/howe-hunter/piper-tts-script/main/install.sh | bash
```

This creates `~/Desktop/piper-tts-script/` with everything organized for easy access.

### 2. Create Warp Workflow (Recommended)
Save this as a Workflow in Warp for instant access:

**Workflow Name**: "TTS Clipboard"
```bash
~/Desktop/piper-tts-script/piper-tts_from_clipboard.sh
```

**Workflow Name**: "TTS Custom Text"
```bash
~/Desktop/piper-tts-script/piper-tts_from_clipboard.sh "{{text_to_speak}}"
```

### 3. Set Up Warp AI Context
Add this context to help Warp's AI understand your TTS workflows:

```
I use a Piper TTS script located at ~/Desktop/piper-tts-script/ for text-to-speech. 
The main script is piper-tts_from_clipboard.sh and it supports:
- Speaking clipboard content
- Speaking custom text as arguments
- Different voice models via PIPER_MODEL environment variable
- Speed control via SPEED_MULTIPLIER in the script
```

## Warp AI-Powered Workflows

### Voice Model Management
Ask Warp AI to help you manage voice models:

```bash
# Ask: "How do I list available TTS voice models?"
ls ~/Desktop/piper-tts-script/voices/

# Ask: "Download the American English TTS model"
cd ~/Desktop/piper-tts-script/voices && curl -L "https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx" -o en_US-lessac-medium.onnx
```

### Smart TTS Commands
Let Warp AI suggest optimized commands:

```bash
# Copy text and speak it
echo "Hello from Warp!" | pbcopy && ~/Desktop/piper-tts-script/piper-tts_from_clipboard.sh

# Speak with different voice
PIPER_MODEL=en_US-lessac-medium ~/Desktop/piper-tts-script/piper-tts_from_clipboard.sh "Testing American voice"

# Debug mode for troubleshooting
DEBUG=1 ~/Desktop/piper-tts-script/piper-tts_from_clipboard.sh "Debug test"
```

## Warp Blocks for TTS

Save these as reusable Warp Blocks:

### Block 1: "TTS Setup Check"
```bash
#!/bin/bash
echo "🔍 Checking TTS Setup..."
echo "Script location: $(ls -la ~/Desktop/piper-tts-script/piper-tts_from_clipboard.sh)"
echo "Available voices: $(ls ~/Desktop/piper-tts-script/voices/ 2>/dev/null || echo 'No voices found')"
echo "Piper binary: $(which piper)"
echo "FFmpeg: $(which ffmpeg)"
```

### Block 2: "Quick TTS Test"
```bash
#!/bin/bash
echo "🔊 Testing TTS with sample text..."
~/Desktop/piper-tts-script/piper-tts_from_clipboard.sh "Warp Terminal TTS test successful!"
```

### Block 3: "TTS Voice Switcher"
```bash
#!/bin/bash
echo "🎭 Available voice models:"
ls ~/Desktop/piper-tts-script/voices/*.onnx 2>/dev/null | sed 's/.*\///; s/\.onnx$//' | nl
echo ""
read -p "Select voice number (or press Enter for default): " choice
if [ -n "$choice" ]; then
    voice=$(ls ~/Desktop/piper-tts-script/voices/*.onnx 2>/dev/null | sed 's/.*\///; s/\.onnx$//' | sed -n "${choice}p")
    echo "Using voice: $voice"
    PIPER_MODEL="$voice" ~/Desktop/piper-tts-script/piper-tts_from_clipboard.sh "Voice test with $voice"
else
    ~/Desktop/piper-tts-script/piper-tts_from_clipboard.sh "Default voice test"
fi
```

## Warp Drive Integration

Store your TTS configurations in Warp Drive for team sharing:

### Shared Team Config
```bash
# ~/.warp/tts-config.sh
export PIPER_MODEL="en_GB-alba-medium"  # Team default voice
export TTS_SCRIPT="$HOME/Desktop/piper-tts-script/piper-tts_from_clipboard.sh"

# Convenient aliases
alias tts="$TTS_SCRIPT"
alias tts-test="$TTS_SCRIPT 'Warp TTS is working!'"
alias tts-american="PIPER_MODEL=en_US-lessac-medium $TTS_SCRIPT"
alias tts-debug="DEBUG=1 $TTS_SCRIPT"
```

Load it in your shell profile:
```bash
source ~/.warp/tts-config.sh
```

## AI-Assisted Troubleshooting

Use Warp AI to help diagnose TTS issues:

### Common Warp AI Prompts:
- "My TTS script isn't working, help me debug"
- "How do I change the TTS voice model?"
- "Create a command to test if my TTS setup is working"
- "Show me all available TTS voice models"

### Debug Workflow Block:
```bash
#!/bin/bash
echo "🔧 TTS Diagnostic Report"
echo "========================"
echo "Date: $(date)"
echo "Warp Version: $WARP_VERSION"
echo "macOS Version: $(sw_vers -productVersion)"
echo ""
echo "TTS Script Status:"
ls -la ~/Desktop/piper-tts-script/piper-tts_from_clipboard.sh
echo ""
echo "Voice Models:"
ls -la ~/Desktop/piper-tts-script/voices/
echo ""
echo "Dependencies:"
echo "- Homebrew: $(which brew)"
echo "- FFmpeg: $(which ffmpeg)"
echo "- Piper: $(which piper)"
echo ""
echo "Running basic test..."
DEBUG=1 ~/Desktop/piper-tts-script/piper-tts_from_clipboard.sh "Warp diagnostic test"
```

## Warp Terminal Themes for TTS

Enhance your TTS workflow with custom Warp themes:

### "TTS Developer" Theme
- Dark background for focus during long TTS sessions
- High contrast for reading debug output
- Comfortable colors for extended terminal use

## Advanced Warp Features

### 1. Command Palette Integration
Add TTS commands to Warp's command palette:
- `Cmd+P` → "Run TTS Clipboard"
- `Cmd+P` → "Test TTS Setup"
- `Cmd+P` → "Switch TTS Voice"

### 2. Smart Suggestions
Warp learns your TTS patterns and suggests:
- Recently used voice models
- Common text-to-speech commands
- Debug commands when issues occur

### 3. Workflow Automation
Create automated workflows that:
- Test TTS setup on new machine setup
- Download and configure new voice models
- Run TTS health checks as part of daily workflows

## Integration with Other Warp Features

### Warp AI Chat Integration
Ask Warp AI about TTS workflows:
- "Create a script to batch convert text files to speech"
- "How can I automate TTS for my documentation?"
- "Set up TTS for accessibility in my development workflow"

### Session Sharing
Share TTS-enabled terminal sessions:
- Demo voice model capabilities
- Collaborative debugging of TTS issues
- Team onboarding with audio feedback

## Performance Tips for Warp + TTS

1. **Preload Models**: Keep commonly used voice models in the voices directory
2. **Background Processing**: Use `&` for long TTS tasks while continuing work
3. **Memory Management**: Close unused TTS processes to keep Warp responsive
4. **Smart Caching**: Warp caches command history for quick TTS command access

## Troubleshooting in Warp

Common issues and Warp-specific solutions:

### Audio Not Working
```bash
# Quick audio test in Warp
ffplay /System/Library/Sounds/Ping.aiff

# Check audio devices
system_profiler SPAudioDataType
```

### Warp AI Not Recognizing TTS Commands
Update your Warp AI context with TTS-specific information and commonly used commands.

### Performance Issues
- Use Warp's process monitor to check TTS resource usage
- Enable Warp's smart completion for faster command entry
- Utilize Warp's command caching for frequently used TTS operations

## Community and Support

- **Warp Community**: Share TTS workflows and get help
- **GitHub Issues**: Report TTS script bugs and feature requests
- **Warp Discord**: Get real-time help with TTS integration

---

*This guide showcases the powerful combination of Warp Terminal's AI capabilities with the Piper TTS script for an enhanced development experience.*
