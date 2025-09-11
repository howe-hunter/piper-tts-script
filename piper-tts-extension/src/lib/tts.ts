import { exec } from "child_process";
import { promisify } from "util";
import { existsSync } from "fs";
import { homedir } from "os";
import { join } from "path";
import { Clipboard, getPreferenceValues, showToast, Toast } from "@raycast/api";

const execAsync = promisify(exec);

export interface TTSPreferences {
  voiceModel: string;
  defaultSpeed: string;
  autoInstallDeps: boolean;
}

export interface SpeedOption {
  name: string;
  value: string;
  emoji: string;
  description: string;
}

export const SPEED_OPTIONS: SpeedOption[] = [
  { name: "Slow & Clear", value: "0.8", emoji: "🐌", description: "Perfect for learning" },
  { name: "Normal Speed", value: "1.0", emoji: "🚶", description: "Standard speech rate" },
  { name: "Comfortable Fast", value: "1.5", emoji: "🏃", description: "Efficient listening" },
  { name: "Double Speed", value: "2.0", emoji: "🏎️", description: "Default setting" },
  { name: "Very Fast", value: "2.5", emoji: "⚡", description: "For experienced users" },
  { name: "Maximum Speed", value: "3.0", emoji: "🚀", description: "Ultra-fast" },
];

/**
 * Check if a command exists in the system PATH
 */
async function commandExists(command: string): Promise<boolean> {
  try {
    await execAsync(`which ${command}`);
    return true;
  } catch {
    return false;
  }
}

/**
 * Find the Piper TTS binary in common locations
 */
async function findPiper(): Promise<string | null> {
  const locations = [
    join(homedir(), ".local", "bin", "piper"),
    "/opt/homebrew/bin/piper",
    "/usr/local/bin/piper",
  ];

  for (const location of locations) {
    if (existsSync(location)) {
      return location;
    }
  }

  // Check if it's in PATH
  if (await commandExists("piper")) {
    return "piper";
  }

  return null;
}

/**
 * Find the voice models directory
 */
function findVoiceDir(): string {
  const locations = [
    join(homedir(), ".local", "share", "piper", "models"),
    join(homedir(), "Documents", "piper-voices"),
    join(homedir(), "piper-voices"),
  ];

  for (const dir of locations) {
    if (existsSync(dir)) {
      return dir;
    }
  }

  // Return default location (will be created if needed)
  return join(homedir(), ".local", "share", "piper", "models");
}

/**
 * Install missing dependencies
 */
export async function installDependencies(): Promise<void> {
  const toast = await showToast({
    style: Toast.Style.Animated,
    title: "Installing Dependencies...",
    message: "This may take a few minutes",
  });

  try {
    // Check for Homebrew
    if (!(await commandExists("brew"))) {
      throw new Error("Homebrew not found. Please install Homebrew first.");
    }

    // Install ffmpeg if missing
    if (!(await commandExists("ffmpeg"))) {
      toast.message = "Installing ffmpeg...";
      await execAsync("brew install ffmpeg");
    }

    // Install pipx if missing
    if (!(await commandExists("pipx"))) {
      toast.message = "Installing pipx...";
      await execAsync("brew install pipx");
    }

    // Install piper-tts if missing
    if (!(await findPiper())) {
      toast.message = "Installing piper-tts...";
      await execAsync("pipx install piper-tts");
    }

    toast.style = Toast.Style.Success;
    toast.title = "Dependencies Installed";
    toast.message = "All required dependencies are now available";
  } catch (error) {
    toast.style = Toast.Style.Failure;
    toast.title = "Installation Failed";
    toast.message = error instanceof Error ? error.message : "Unknown error occurred";
    throw error;
  }
}

/**
 * Download a voice model if it doesn't exist
 */
async function downloadVoiceModel(modelName: string, voiceDir: string): Promise<void> {
  const modelPath = join(voiceDir, `${modelName}.onnx`);
  if (existsSync(modelPath)) {
    return;
  }

  const toast = await showToast({
    style: Toast.Style.Animated,
    title: "Downloading Voice Model...",
    message: `Downloading ${modelName}`,
  });

  try {
    // Create voice directory if it doesn't exist
    await execAsync(`mkdir -p "${voiceDir}"`);

    let baseUrl: string;
    let sourceName: string;

    switch (modelName) {
      case "en_GB-alba-medium":
        baseUrl = "https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_GB/alba/medium";
        sourceName = "en_GB-alba-medium";
        break;
      case "en_US-lessac-medium":
        baseUrl =
          "https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium";
        sourceName = "en_US-lessac-medium";
        break;
      case "fr_FR-siwis-medium":
        baseUrl =
          "https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/fr/fr_FR/siwis/medium";
        sourceName = "fr_FR-siwis-medium";
        break;
      case "de_DE-thorsten-medium":
        baseUrl =
          "https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/de/de_DE/thorsten/medium";
        sourceName = "de_DE-thorsten-medium";
        break;
      case "es_ES-davefx-medium":
        baseUrl =
          "https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/es/es_ES/davefx/medium";
        sourceName = "es_ES-davefx-medium";
        break;
      default:
        throw new Error(`Unknown voice model: ${modelName}`);
    }

    // Download model files
    await execAsync(`curl -L "${baseUrl}/${sourceName}.onnx" -o "${voiceDir}/${modelName}.onnx"`);
    await execAsync(
      `curl -L "${baseUrl}/${sourceName}.onnx.json" -o "${voiceDir}/${modelName}.onnx.json"`
    );

    toast.style = Toast.Style.Success;
    toast.title = "Voice Model Downloaded";
    toast.message = `${modelName} is ready to use`;
  } catch (error) {
    toast.style = Toast.Style.Failure;
    toast.title = "Download Failed";
    toast.message = error instanceof Error ? error.message : "Failed to download voice model";
    throw error;
  }
}

/**
 * Check if all dependencies are installed
 */
export async function checkDependencies(): Promise<boolean> {
  try {
    const hasHomebrew = await commandExists("brew");
    const hasFFmpeg = await commandExists("ffmpeg");
    const hasPiper = (await findPiper()) !== null;

    return hasHomebrew && hasFFmpeg && hasPiper;
  } catch {
    return false;
  }
}

/**
 * Generate and play TTS audio
 */
export async function speakText(text: string, speed?: string): Promise<void> {
  const preferences = getPreferenceValues<TTSPreferences>();
  const finalSpeed = speed || preferences.defaultSpeed;

  // Check if text is provided
  if (!text.trim()) {
    throw new Error("No text provided to speak");
  }

  if (text.length > 1000) {
    throw new Error(`Text too long (${text.length} characters). Maximum is 1000 characters.`);
  }

  const toast = await showToast({
    style: Toast.Style.Animated,
    title: "Generating Speech...",
    message: `Speed: ${finalSpeed}x`,
  });

  try {
    // Check dependencies
    if (preferences.autoInstallDeps && !(await checkDependencies())) {
      await installDependencies();
    }

    // Find Piper binary
    const piperCmd = await findPiper();
    if (!piperCmd) {
      throw new Error(
        "Piper TTS not found. Please install it or enable auto-install in preferences."
      );
    }

    // Find voice directory
    const voiceDir = findVoiceDir();

    // Download voice model if needed
    await downloadVoiceModel(preferences.voiceModel, voiceDir);

    // Generate temporary file names
    const tempWav = `/tmp/piper_raycast_${Date.now()}.wav`;
    const tempFastWav = `/tmp/piper_raycast_fast_${Date.now()}.wav`;

    try {
      toast.message = "Synthesizing audio...";

      // Generate TTS audio
      await execAsync(
        `"${piperCmd}" -m "${preferences.voiceModel}" --data-dir "${voiceDir}" -f "${tempWav}" <<< ${JSON.stringify(text)}`
      );

      // Apply speed adjustment if not 1.0
      let finalAudio = tempWav;
      if (finalSpeed !== "1.0") {
        toast.message = `Adjusting speed to ${finalSpeed}x...`;
        await execAsync(
          `ffmpeg -y -i "${tempWav}" -filter:a "atempo=${finalSpeed}" "${tempFastWav}" 2>/dev/null`
        );
        finalAudio = tempFastWav;
      }

      toast.message = "Playing audio...";
      // Play the audio
      await execAsync(`ffplay -autoexit -nodisp "${finalAudio}" 2>/dev/null`);

      toast.style = Toast.Style.Success;
      toast.title = "Speech Complete";
      toast.message = `Played at ${finalSpeed}x speed`;
    } finally {
      // Clean up temporary files
      try {
        await execAsync(`rm -f "${tempWav}" "${tempFastWav}"`);
      } catch {
        // Ignore cleanup errors
      }
    }
  } catch (error) {
    toast.style = Toast.Style.Failure;
    toast.title = "Speech Failed";
    toast.message = error instanceof Error ? error.message : "Unknown error occurred";
    throw error;
  }
}

/**
 * Get clipboard text for TTS
 */
export async function getClipboardText(): Promise<string> {
  try {
    const clipboardText = await Clipboard.readText();
    if (!clipboardText || !clipboardText.trim()) {
      throw new Error("Clipboard is empty. Please copy some text and try again.");
    }
    return clipboardText.trim();
  } catch (error) {
    throw new Error("Failed to read clipboard content");
  }
}
