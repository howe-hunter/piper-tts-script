import { showToast, Toast, Clipboard } from "@raycast/api";

export default async function Command() {
  try {
    // Simple clipboard reading
    const clipboardText = await Clipboard.readText();

    if (!clipboardText || !clipboardText.trim()) {
      await showToast({
        style: Toast.Style.Failure,
        title: "Clipboard is empty",
        message: "Please copy some text and try again",
      });
      return;
    }

    // Simple TTS implementation using system say command
    const { exec } = await import("child_process");
    const { promisify } = await import("util");
    const execAsync = promisify(exec);

    await showToast({
      style: Toast.Style.Animated,
      title: "Speaking...",
      message: `Playing at 2x speed`,
    });

    // Use system say command with faster rate
    await execAsync(`say -r 400 ${JSON.stringify(clipboardText)}`);

    await showToast({
      style: Toast.Style.Success,
      title: "Speech Complete",
      message: "Finished speaking clipboard text",
    });
  } catch (error) {
    await showToast({
      style: Toast.Style.Failure,
      title: "Speech Failed",
      message: error instanceof Error ? error.message : "Unknown error occurred",
    });
  }
}
