# 🔊 Piper TTS Clipboard Script

> 🤖 **Created through "vibe coding" with AI assistance** - This script was developed collaboratively using [Perplexity AI](https://perplexity.ai) for research and [Warp Terminal's Agent Mode](https://warp.dev) for implementation. It's a prime example of human creativity enhanced by AI tools to solve real-world problems.

A robust, user-friendly script that converts text to speech using [Piper TTS](https://github.com/rhasspy/piper) with customizable playback speed. Perfect for Raycast integration or command-line use.

## ✨ Features

- **Smart Installation**: Automatically detects and installs missing dependencies
- **Multi-Environment Support**: Works in Terminal, Raycast, and other automation tools  
- **Voice Model Management**: Automatically finds and downloads voice models
- **Customizable Speed**: Adjustable playback speed (default 2x)
- **Robust Error Handling**: Clear error messages and graceful failure handling
- **Multiple Input Sources**: Use clipboard content or provide text as arguments
- **AI-Enhanced Development**: Built through collaborative human-AI "vibe coding" for maximum robustness

## 🚀 Quick Start

### Option 1: Automatic Installation (Recommended)
1. Download the script: `piper-tts_from_clipboard.sh`
2. Make it executable: `chmod +x piper-tts_from_clipboard.sh`
3. Run it in Terminal: `./piper-tts_from_clipboard.sh`
4. The script will automatically install all dependencies on first run

### Option 2: Manual Installation
```bash
# Install dependencies
brew install ffmpeg pipx
pipx install piper-tts

# Download and run the script
curl -O https://your-link/piper-tts_from_clipboard.sh
chmod +x piper-tts_from_clipboard.sh
./piper-tts_from_clipboard.sh
```

## 📖 Usage

### Basic Usage
```bash
# Speak clipboard content
./piper-tts_from_clipboard.sh

# Speak provided text
./piper-tts_from_clipboard.sh "Hello, world!"

# Show help
./piper-tts_from_clipboard.sh --help
```

### Raycast Integration
1. Add the script to Raycast as a Script Command
2. Use the exact path to the script file
3. The script will automatically work without PATH issues

### Advanced Configuration

#### Environment Variables
```bash
# Use a different voice model
export PIPER_MODEL="en_GB-alba-medium"
./piper-tts_from_clipboard.sh

# Custom voice models directory
export PIPER_VOICES_DIR="/path/to/your/voices"
./piper-tts_from_clipboard.sh
```

#### Speed Adjustment
Edit the script and change the `SPEED_MULTIPLIER` variable:
```bash
SPEED_MULTIPLIER="1.5"  # 1.5x speed
SPEED_MULTIPLIER="1.0"  # Normal speed
SPEED_MULTIPLIER="3.0"  # 3x speed
```

## 🎭 Voice Models

### Default Model
The script uses `en_US-lessac-medium` by default, which provides high-quality American English speech.

### Additional Models
You can download additional voice models from [Hugging Face](https://huggingface.co/rhasspy/piper-voices):

```bash
# Download a British English model
cd ~/.local/share/piper/models
curl -L https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/alba/medium/en_GB-alba-medium.onnx -o en_GB-alba-medium.onnx
curl -L https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/alba/medium/en_GB-alba-medium.onnx.json -o en_GB-alba-medium.onnx.json

# Use the new model
PIPER_MODEL=en_GB-alba-medium ./piper-tts_from_clipboard.sh
```

### Supported Languages
Piper TTS supports many languages including:
- English (US, UK, Australia)
- Spanish, French, German, Italian
- Dutch, Portuguese, Russian
- And many more!

## 🔧 Troubleshooting

### Common Issues

#### "Dependency not found" errors
- **Solution**: Run the script in Terminal first to auto-install dependencies
- **Alternative**: Install manually with `brew install ffmpeg pipx && pipx install piper-tts`

#### "Voice model not found" errors
- **Solution**: The script will auto-download the default model on first run
- **Manual fix**: Check available models with `ls ~/.local/share/piper/models/`

#### Raycast PATH issues
- The script automatically handles PATH issues by using full paths to commands
- No additional configuration needed

#### Audio playback issues
- Check your audio output settings
- Try running: `ffplay /System/Library/Sounds/Ping.aiff` to test audio

### Debug Mode
Enable verbose output by editing the script and changing error redirections:
```bash
# Change this line:
if ! "$PIPER_CMD" -m "$MODEL" --data-dir "$VOICE_DIR" -f "$TMPWAV" -- "$TEXT" 2>/dev/null; then

# To this:
if ! "$PIPER_CMD" -m "$MODEL" --data-dir "$VOICE_DIR" -f "$TMPWAV" -- "$TEXT"; then
```

## 🛠️ System Requirements

- **Operating System**: macOS (tested on macOS 11+)
- **Dependencies**: 
  - Homebrew (auto-installed if missing)
  - ffmpeg (auto-installed)
  - piper-tts (auto-installed)
- **Disk Space**: ~50MB for dependencies + voice models
- **Network**: Required for initial dependency and model downloads

## 📁 File Locations

- **Script**: Place anywhere you prefer
- **Voice Models**: `~/.local/share/piper/models/`
- **Temporary Files**: `/tmp/piper_clip_*.wav` (auto-cleaned)
- **Piper Binary**: `~/.local/bin/piper` (via pipx)

## 🎯 Use Cases

### Personal Productivity
- Convert long articles to audio for listening while walking
- Read aloud important emails or documents
- Accessibility support for visual impairments

### Content Creation
- Generate voiceovers for videos
- Create audio versions of written content
- Test pronunciation of text

### Development
- Audio notifications for build completions
- Reading error messages aloud
- Accessibility testing

## 🤝 Contributing

Feel free to modify and improve the script! Some ideas:
- Add support for more audio formats
- Implement voice selection UI
- Add batch processing capabilities
- Create a GUI version

## 📚 Development Story

This project showcases the power of **"vibe coding"** - collaborative development between humans and AI:

### The Journey:
1. **🎯 Problem**: Simple TTS script that only worked in specific environments
2. **🔍 Research**: Used [Perplexity AI](https://perplexity.ai) to research Piper TTS capabilities and best practices
3. **🚀 Implementation**: Leveraged [Warp Terminal's Agent Mode](https://warp.dev) to iteratively build and test
4. **🛠️ Refinement**: Through multiple iterations, transformed a basic script into a production-ready tool
5. **📄 Documentation**: AI assistance helped create comprehensive documentation and error handling

### What AI Helped With:
- **Robust error handling** - Anticipating edge cases and failure modes
- **Cross-environment compatibility** - Handling different macOS setups and PATH configurations
- **Dependency management** - Automatic installation and verification logic
- **User experience** - Clear messaging, help systems, and installation scripts
- **Documentation** - Comprehensive README with troubleshooting guides

### Human Creativity:
- **Original vision** - Text-to-speech automation for productivity
- **Requirements definition** - Making it shareable and user-friendly
- **Testing and validation** - Real-world usage and iteration
- **Design decisions** - Balancing features with simplicity

**Result**: What started as a 60-line personal script became a 341-line robust tool that anyone can use!

## 📄 License

This script is provided as-is for personal and educational use. Piper TTS is licensed under the MIT License.

## 🙏 Acknowledgments

### Core Technology
- **[Piper TTS](https://github.com/rhasspy/piper)** by [Rhasspy](https://github.com/rhasspy) - The fantastic open-source neural text-to-speech system that powers this script
- **[Rhasspy Community](https://github.com/rhasspy)** - For creating and maintaining high-quality voice models

### Development Tools
- **[Perplexity AI](https://perplexity.ai)** - Research and problem-solving assistance
- **[Warp Terminal](https://warp.dev)** - AI-powered terminal with Agent Mode for collaborative coding
- **[Raycast](https://raycast.com/)** - The automation platform that inspired better cross-environment compatibility

### Infrastructure
- **[Homebrew](https://brew.sh/)** - macOS package management
- **[pipx](https://pipx.pypa.io/)** - Isolated Python application installation
- **[Hugging Face](https://huggingface.co/rhasspy/piper-voices)** - Voice model distribution

### Inspiration
This project demonstrates the potential of **human-AI collaboration** in software development - where human creativity and problem-solving combines with AI's ability to handle complexity, edge cases, and comprehensive documentation.
