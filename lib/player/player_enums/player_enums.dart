/// Defines the shape of the play icon displayed in the audio player.
enum PlayIconShapeType {
  /// A circular play button.
  circular,

  /// A rounded rectangle play button.
  roundedRectangle,

  /// A square-shaped play button.
  square,
}

/// Defines the style variations for the audio player UI.
enum PlayerStyle {
  /// Style variation 1.
  style1,

  /// Style variation 2.
  style2,

  /// Style variation 3.
  style3,

  /// Style variation 4. (Note: Check spelling - "stlye4" may be a typo)
  style4,

  /// Style variation 5.
  style5,
}

/// Represents the source type of the audio file.
enum AudioType {
  /// An audio file accessed directly from a file path.
  directFile,

  /// An audio file bundled within the app's assets.
  assets,

  /// An audio file accessed from a remote URL.
  url,

  blobforWeb,
}
