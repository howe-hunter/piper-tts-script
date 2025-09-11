import { showToast, Toast, Clipboard } from "@raycast/api";

const SPEED_OPTIONS = [
  { name: "Slow & Clear", value: "0.8", rate: 150, emoji: "🐌" },
  { name: "Normal Speed", value: "1.0", rate: 200, emoji: "🚶" },
  { name: "Comfortable Fast", value: "1.5", rate: 300, emoji: "🏃" },
  { name: "Double Speed", value: "2.0", rate: 400, emoji: "🏎️" },
  { name: "Very Fast", value: "2.5", rate: 500, emoji: "⚡" },
  { name: "Maximum Speed", value: "3.0", rate: 600, emoji: "🚀" },
];

export default async function Command() {
  try {
    // Get clipboard text
    const clipboardText = await Clipboard.readText();

    if (!clipboardText || !clipboardText.trim()) {
      await showToast({
        style: Toast.Style.Failure,
        title: "Clipboard is empty",
        message: "Please copy some text and try again",
      });
      return;
    }

    // For now, just use 1.5x speed (comfortable fast)
    // In a full implementation, this would show a menu
    const selectedSpeed = SPEED_OPTIONS[2]; // 1.5x speed

    await showToast({
      style: Toast.Style.Animated,
      title: "Speaking...",
      message: `${selectedSpeed.emoji} ${selectedSpeed.value}x - ${selectedSpeed.name}`,
    });

    // Use system say command
    const { exec } = await import("child_process");
    const { promisify } = await import("util");
    const execAsync = promisify(exec);

    await execAsync(`say -r ${selectedSpeed.rate} ${JSON.stringify(clipboardText)}`);

    await showToast({
      style: Toast.Style.Success,
      title: "Speech Complete",
      message: `Played at ${selectedSpeed.value}x speed`,
    });
  } catch (error) {
    await showToast({
      style: Toast.Style.Failure,
      title: "Speech Failed",
      message: error instanceof Error ? error.message : "Unknown error occurred",
    });
  }
}
