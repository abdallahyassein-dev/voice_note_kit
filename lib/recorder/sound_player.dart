import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Plays an audio file from assets using the `just_audio` package.
///
/// - `assetPath`: The path to the asset (e.g., 'assets/audio/my_sound.mp3') that you want to play.
Future<void> playSound(String assetPath) async {
  try {
    // Create an instance of the AudioPlayer from just_audio
    final player = AudioPlayer();

    // Load the audio file from the assets
    final byteData = await rootBundle.load(assetPath);

    // Get the temporary directory where we will store the audio file
    final file = File('${(await getTemporaryDirectory()).path}/temp_sound.mp3');

    // Write the loaded asset data to a file in the temporary directory
    await file.writeAsBytes(byteData.buffer.asUint8List());

    // Set the path of the file to the audio player
    await player.setFilePath(file.path);

    // Play the audio
    await player.play();
  } catch (e) {
    // If an error occurs, rethrow it to be handled by the caller
    rethrow;
  }
}
