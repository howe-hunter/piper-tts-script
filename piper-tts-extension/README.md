# Piper Text-to-Speech Extension for Raycast

🔊 Convert clipboard text to high-quality speech with native macOS voice synthesis.

**Perfect for:** Listening to articles, emails, and web content at custom speeds while multitasking.

## Features

- 🔊 **Instant Speech**: Copy text and speak it immediately
- ⚡ **Speed Control**: Multiple speed options (0.8x to 3.0x)
- 🎯 **Native Integration**: Built for Raycast with native UI
- 📋 **Smart Clipboard**: Automatic text detection and validation
- ⚙️ **Preferences**: Configurable voice models and speeds
- 🚀 **Lightweight**: Uses system speech synthesis (no external dependencies)

## Commands

### 🔊 Speak Clipboard
Instantly speak clipboard content at 2x speed (400 WPM). Perfect for quick listening.

### ⚡ Speak with Speed (1.5x)
Speak clipboard content at 1.5x speed (300 WPM). Ideal for comfortable fast listening.

### ⚙️ TTS Preferences
Open the extension preferences to configure voice models and default speeds.

## Speed Options

The extension supports multiple speech rates:
- 🐌 **0.8x** (150 WPM) - Slow & Clear (perfect for learning)
- 🚶 **1.0x** (200 WPM) - Normal Speed (standard speech rate)  
- 🏃 **1.5x** (300 WPM) - Comfortable Fast (efficient listening)
- 🏎️ **2.0x** (400 WPM) - Double Speed (default)
- ⚡ **2.5x** (500 WPM) - Very Fast (for experienced users)
- 🚀 **3.0x** (600 WPM) - Maximum Speed (ultra-fast)

## Installation

1. Install the extension in Raycast
2. The extension will automatically install dependencies when first used
3. Voice models download automatically as needed

### Manual Dependencies (if auto-install fails)

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required packages
brew install ffmpeg pipx
pipx install piper-tts
```

## Configuration

Access preferences via `Cmd+,` in any command or through the Preferences command.

### Voice Models
- **British English (Alba)** - Clear, professional (default)
- **American English (Lessac)** - Natural, expressive
- **French (Siwis)** - Native speaker quality
- **German (Thorsten)** - Clear pronunciation
- **Spanish (Davefx)** - Natural accent

### Auto-install Dependencies
Enable to automatically install required components (Homebrew, ffmpeg, piper-tts).

## Usage Examples

### Daily Workflow
1. **Copy any text** - articles, emails, PDFs, web pages
2. **Quick TTS**: `Cmd+Space` → "Speak Clipboard" → `Enter`
3. **Custom speed**: `Cmd+Space` → "Speak with Speed" → choose option

### Perfect For
- 📰 **News articles** at 2x speed while multitasking
- 📚 **Learning content** at 0.8x for better comprehension  
- 📧 **Email processing** at 1.5x for efficiency
- 📖 **Long documents** at custom speeds

## Technical Details

### File Locations
- **Voice models**: `~/.local/share/piper/models/`
- **Piper binary**: `~/.local/bin/piper` 
- **Temporary files**: `/tmp/piper_raycast_*.wav`

### System Requirements
- **macOS** 11+ (Big Sur or newer)
- **50MB** disk space for voice models
- **Internet** for initial setup and voice downloads
- **Audio output** (speakers/headphones)

## Troubleshooting

### No Sound
- Check volume and audio output device
- Verify ffmpeg installation: `ffmpeg -version`
- Use Preferences command to check dependencies

### Dependencies Missing  
- Enable "Auto-install Dependencies" in preferences
- Or manually install via Terminal (see Installation section)

### Voice Model Issues
- Models download automatically on first use
- Check internet connection for downloads
- Verify disk space (50MB+ required)

## Development

```bash
# Install dependencies
npm install

# Development mode
npm run dev

# Build for production  
npm run build

# Lint code
npm run lint
```

## Credits

**Powered by:**
- [Piper TTS](https://github.com/rhasspy/piper) - Neural text-to-speech engine
- [Rhasspy Community](https://github.com/rhasspy) - Voice models
- [Raycast](https://raycast.com) - Extensible launcher

Built with ❤️ using the [Raycast Extensions API](https://developers.raycast.com)
