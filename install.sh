#!/bin/bash

# =============================================================================
# Piper TTS Script Installer
# =============================================================================

set -e  # Exit on any error

echo "🔊 Installing Piper TTS Clipboard Script..."
echo

# Create installation directory
INSTALL_DIR="$HOME/piper-tts-script"
mkdir -p "$INSTALL_DIR"

# Download script files
echo "📥 Downloading script files..."
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "https://raw.githubusercontent.com/howe-hunter/piper-tts-script/main/piper-tts_from_clipboard.sh" -o "$INSTALL_DIR/piper-tts_from_clipboard.sh"
    curl -fsSL "https://raw.githubusercontent.com/howe-hunter/piper-tts-script/main/README.md" -o "$INSTALL_DIR/README.md"
else
    echo "❌ curl not found. Please install curl first."
    exit 1
fi

# Make script executable
chmod +x "$INSTALL_DIR/piper-tts_from_clipboard.sh"

# Run initial setup
echo "⚙️ Running initial setup..."
cd "$INSTALL_DIR"
./piper-tts_from_clipboard.sh "Installation complete" || {
    echo "⚠️ Initial setup encountered issues, but the script is installed."
    echo "You may need to run it manually in Terminal first to install dependencies."
}

# Add to PATH (optional)
echo
echo "🎉 Installation complete!"
echo
echo "📍 Script installed to: $INSTALL_DIR"
echo "📖 Documentation: $INSTALL_DIR/README.md"
echo
echo "🚀 Quick start:"
echo "  $INSTALL_DIR/piper-tts_from_clipboard.sh \"Hello world\""
echo
echo "💡 For Raycast integration:"
echo "  1. Add Script Command in Raycast"
echo "  2. Set script path to: $INSTALL_DIR/piper-tts_from_clipboard.sh"
echo
echo "📚 Run --help for more options:"
echo "  $INSTALL_DIR/piper-tts_from_clipboard.sh --help"
echo

# Optionally add to PATH
read -p "Would you like to add the script to your PATH for easy access? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Create symlink in a common PATH location
    SYMLINK_PATH="/usr/local/bin/piper-tts"
    if [ -w "/usr/local/bin" ]; then
        ln -sf "$INSTALL_DIR/piper-tts_from_clipboard.sh" "$SYMLINK_PATH"
        echo "✅ Added to PATH. You can now run: piper-tts"
    else
        echo "⚠️ Cannot write to /usr/local/bin. You may need to run with sudo:"
        echo "  sudo ln -sf '$INSTALL_DIR/piper-tts_from_clipboard.sh' '/usr/local/bin/piper-tts'"
    fi
fi

echo
echo "🎊 Setup complete! Enjoy your new text-to-speech tool!"
