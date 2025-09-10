# Piper TTS Script for Raycast

> Convert text to high-quality speech using [Piper TTS](https://github.com/rhasspy/piper) with seamless Raycast integration

**Perfect for:** Listening to articles, emails, and web content at 2x speed while multitasking.

## ✨ Features
- 🔊 **Instant speech**: Copy text, run command, hear it spoken
- ⚡ **Speed control**: Interactive speed selector (0.8x to 3.0x)
- 🤖 **Auto-setup**: Installs all dependencies automatically
- 🎯 **Raycast optimized**: Built specifically for Raycast integration
- 🌍 **Multi-language**: Support for 40+ languages and voices
- 💾 **Persistent settings**: Remembers your speed preferences

## 🚀 Complete Setup Guide

### Step 1: Install Raycast
1. Download Raycast from [raycast.com](https://raycast.com)
2. Install and launch Raycast
3. Complete the initial setup
4. Test that Raycast opens with `Cmd + Space`

### Step 2: Download TTS Scripts
**Option A: Quick Install (Recommended)**
```bash
# Open Terminal and run this one command:
curl -fsSL https://raw.githubusercontent.com/howe-hunter/piper-tts-script/main/install.sh | bash
```

**Option B: Manual Install**
```bash
# Clone the repository
git clone https://github.com/howe-hunter/piper-tts-script.git
cd piper-tts-script

# Make scripts executable
chmod +x *.sh

# Test installation
./piper-tts_from_clipboard.sh "Installation test"
```

**ℹ️ Note:** The first run installs all dependencies automatically (Homebrew, ffmpeg, piper-tts). This may take 2-3 minutes.

### Step 3: Add Scripts to Raycast

#### 🔊 Basic TTS Command (Speaks at 2x speed)
1. **Open Raycast** (`Cmd + Space`)
2. **Type:** "Create Script Command" and press Enter
3. **Fill out the form:**
   - **Title:** `Speak Clipboard`
   - **Script:** `/path/to/your/piper-tts_from_clipboard.sh`
     - Quick install path: `~/piper-tts-script/piper-tts_from_clipboard.sh`
     - Manual install: `~/piper-tts-script/piper-tts_from_clipboard.sh`
   - **Shell:** `bash`
   - **Mode:** `compact`
   - **Package Name:** `Text to Speech`
   - **Icon:** 🔊 (or any emoji)
   - **Keyword:** `speak` (what you'll type to trigger it)
4. **Click "Create"**

#### ⚡ Speed Selector Command (Choose your speed)
1. **In Raycast**, create another Script Command
2. **Fill out the form:**
   - **Title:** `TTS Speed Selector`
   - **Script:** `/path/to/your/raycast-tts-speed-selector.sh`
     - Quick install path: `~/piper-tts-script/raycast-tts-speed-selector.sh`
     - Manual install: `~/piper-tts-script/raycast-tts-speed-selector.sh`
   - **Shell:** `bash`
   - **Mode:** `fullOutput` ⚠️ **Important: Must be fullOutput for interactive menu!**
   - **Package Name:** `Text to Speech`
   - **Icon:** ⚡ (or any emoji)
   - **Keyword:** `speed` (what you'll type to trigger it)
3. **Click "Create"**

### Step 4: Test Your Setup
1. **Copy some text** (select text and press `Cmd + C`)
2. **Test basic command:**
   - Press `Cmd + Space` → Type `speak` → Press `Enter`
   - You should hear the text at 2x speed
3. **Test speed selector:**
   - Press `Cmd + Space` → Type `speed` → Press `Enter`
   - Choose a speed option → Press `Enter`
   - Text should play at your selected speed

## 🎉 You're Ready!

### Daily Workflow
1. **Copy any text** (`Cmd + C`) - articles, emails, PDFs, web pages
2. **Quick TTS**: `Cmd + Space` → `speak` → `Enter` (plays at 2x speed)
3. **Custom speed**: `Cmd + Space` → `speed` → choose option → `Enter`

### ⚡ Speed Guide
- **🐌 0.8x** - Learning new languages, complex technical content
- **🚶 1.0x** - First-time reading, important documents
- **🏃 1.5x** - Articles, emails, most web content  
- **🏎️ 2.0x** - News, familiar content (default)
- **⚡ 2.5x** - Quick scanning, reviews
- **🚀 3.0x** - Very familiar content

### Pro Tips
- Speed settings are **persistent** - your choice is remembered
- Works with **any text**: web pages, PDFs, emails, documents
- **Multitask** while listening - perfect for long articles
- Use **different voices** by setting `PIPER_MODEL` environment variable

## 🔧 Advanced Customization

### Change Voice (Optional)
Default voice is British English. To use different voices:

```bash
# American English
export PIPER_MODEL="en_US-lessac-medium"

# View available voices
ls ~/.local/share/piper/models/
```

### Voice Downloads
**Popular voices** (auto-download on first use):
- `en_GB-alba-medium` - British English (default)
- `en_US-lessac-medium` - American English
- `fr_FR-siwis-medium` - French
- `de_DE-thorsten-medium` - German
- `es_ES-davefx-medium` - Spanish

**Browse all voices:** [Hugging Face Piper Voices](https://huggingface.co/rhasspy/piper-voices)

### Terminal Usage (Optional)
You can also use the scripts directly in Terminal:
```bash
# Quick TTS
./piper-tts_from_clipboard.sh

# Custom speed
./piper-tts_from_clipboard.sh --speed 1.5

# Specific text
./piper-tts_from_clipboard.sh "Hello world"
```

## 🔍 Troubleshooting

### Common Issues

**❌ "Script not found" in Raycast**
- Use the **full absolute path** to your script file
- Example: `/Users/yourname/piper-tts-script/piper-tts_from_clipboard.sh`
- Don't use `~` - use the complete path starting with `/Users/`

**❌ "Clipboard is empty" message**
- Copy some text first with `Cmd + C`
- The script needs text in your clipboard to work

**❌ No sound / Audio not playing**
- Check your volume and audio output device
- Test audio: run in Terminal first to see error messages
- Make sure no other apps are using audio

**❌ Speed selector shows no menu (Raycast)**
- Make sure Mode is set to `fullOutput` (not `compact`)
- This is required for interactive menus in Raycast

**❌ Dependencies missing**
- Run the script in Terminal once to auto-install everything
- This installs Homebrew, ffmpeg, and piper-tts automatically

### Debug Mode
```bash
# See detailed information
DEBUG=1 ./piper-tts_from_clipboard.sh "test"
```

### System Requirements
- **macOS** 11+ (Big Sur or newer)
- **50MB** disk space
- **Internet** for initial setup
- **Audio output** (speakers/headphones)

---

## 🎆 Credits

**Powered by:**
- [Piper TTS](https://github.com/rhasspy/piper) - Neural text-to-speech engine
- [Rhasspy Community](https://github.com/rhasspy) - Voice models
- [Raycast](https://raycast.com) - Productivity launcher

**Built with AI assistance from:**
- [Warp Terminal](https://warp.dev) - AI-powered terminal
- [Perplexity AI](https://perplexity.ai) - Research assistance

*Enjoy your new superpower! 🎧*
