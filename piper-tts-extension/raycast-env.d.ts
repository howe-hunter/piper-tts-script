/// <reference types="@raycast/api">

/* 🚧 🚧 🚧
 * This file is auto-generated from the extension's manifest.
 * Do not modify manually. Instead, update the `package.json` file.
 * 🚧 🚧 🚧 */

/* eslint-disable @typescript-eslint/ban-types */

type ExtensionPreferences = {
  /** Voice Model - Select the voice model for text-to-speech */
  "voiceModel": "en_GB-alba-medium" | "en_US-lessac-medium" | "fr_FR-siwis-medium" | "de_DE-thorsten-medium" | "es_ES-davefx-medium",
  /** Default Speed - Default playback speed for text-to-speech */
  "defaultSpeed": "0.8" | "1.0" | "1.5" | "2.0" | "2.5" | "3.0",
  /** Auto-install Dependencies - Automatically install required dependencies (Homebrew, ffmpeg, piper-tts) */
  "autoInstallDeps": boolean
}

/** Preferences accessible in all the extension's commands */
declare type Preferences = ExtensionPreferences

declare namespace Preferences {
  /** Preferences accessible in the `speak-clipboard` command */
  export type SpeakClipboard = ExtensionPreferences & {}
  /** Preferences accessible in the `speak-with-speed` command */
  export type SpeakWithSpeed = ExtensionPreferences & {}
  /** Preferences accessible in the `preferences` command */
  export type Preferences = ExtensionPreferences & {}
}

declare namespace Arguments {
  /** Arguments passed to the `speak-clipboard` command */
  export type SpeakClipboard = {}
  /** Arguments passed to the `speak-with-speed` command */
  export type SpeakWithSpeed = {}
  /** Arguments passed to the `preferences` command */
  export type Preferences = {}
}

