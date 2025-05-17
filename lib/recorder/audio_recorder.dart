// ignore_for_file: avoid_print

import 'package:record/record.dart';

/// A class to handle audio recording using the `record` package.
class AudioRecorderClass {
  // Create an instance of the AudioRecorder from the record package
  final _recorder = AudioRecorder();

  /// Starts recording audio with the provided configuration and saves it to the specified path.
  ///
  /// - `config`: Configuration settings for the recording (e.g., sample rate, number of channels, etc.).
  /// - `path`: The file path where the audio will be saved.
  Future<void> start(RecordConfig config, {required String path}) async {
    try {
      // Start the recorder with the given config and path
      await _recorder.start(
        config, // Audio configuration (e.g., settings for the recording)
        path: path, // Path to save the audio file
      );
    } catch (e) {
      // Handle any errors that might occur while starting the recording
      print("Error starting audio recording: $e");
    }
  }

  /// Stops the audio recording.
  Future<String> stop({Function(String)? onWebCallback}) async {
    try {
      // Stop the recording
      String filePath = await _recorder.stop() ?? "";
      return filePath;
    } catch (e) {
      // Handle any errors that might occur while stopping the recording
      print("Error stopping audio recording: $e");
      return "";
    }
  }

  /// Disposes of the recorder when it's no longer needed to release resources.
  void dispose() {
    _recorder.dispose();
  }
}
