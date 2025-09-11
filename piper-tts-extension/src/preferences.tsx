import { showToast, Toast, openCommandPreferences } from "@raycast/api";

export default async function Command() {
  try {
    await showToast({
      style: Toast.Style.Success,
      title: "TTS Preferences",
      message: "Opening Raycast preferences for Text-to-Speech extension",
    });

    // Open the extension preferences
    await openCommandPreferences();
  } catch (error) {
    await showToast({
      style: Toast.Style.Failure,
      title: "Preferences Error",
      message: error instanceof Error ? error.message : "Failed to open preferences",
    });
  }
}
