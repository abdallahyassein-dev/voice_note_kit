import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_note_kit/player/player_enums/player_enums.dart';
import 'package:http/http.dart' as http;

/// Extracts the waveform from an audio file and normalizes the amplitude values.
///
/// [audioFile] - The audio file from which the waveform is to be extracted.
/// Returns a list of normalized waveform values (amplitude) between 0.0 and 1.0.
Future<List<double>> extrectWaveform(File audioFile) async {
  try {
    // Define an output file for the waveform data.
    final outputFile = File('${audioFile.path}_waveform.wave');

    // Extract the waveform data from the audio file asynchronously.
    final waveformStream = JustWaveform.extract(
      audioInFile: audioFile,
      waveOutFile: outputFile,
    );

    // Wait for the waveform extraction to complete and get the waveform data.
    final waveform = await waveformStream.last;

    // Normalize the waveform amplitude between 0.0 and 1.0 and return the data.
    return waveform.waveform!.data.map((e) => e.toDouble() / 32768.0).toList();
  } catch (e) {
    // Log any errors that occur during the extraction process.
    log(e.toString());
    // Return an empty list if there is an error.
    return [];
  }
}

/// Generates a waveform for the given audio source and returns the waveform data.
///
/// [audioType] - The type of audio source (asset, URL, or direct file).
/// [audioPath] - The path to the audio file or URL.
/// Returns a list of waveform amplitude values if successful, otherwise an empty list.
Future<List<double>> generateWaveform(
    AudioType audioType, String? audioPath) async {
  try {
    File? audioFile;

    // Handle the case where the audio file is stored as an asset.
    if (audioType == AudioType.assets && audioPath != null) {
      final byteData = await rootBundle.load(audioPath);
      final tempDir = await getTemporaryDirectory();
      audioFile = File('${tempDir.path}/asset_audio.mp3');
      // Save the audio asset data to a temporary file.
      await audioFile.writeAsBytes(byteData.buffer.asUint8List());
    }
    // Handle the case where the audio file is hosted on a URL.
    else if (audioType == AudioType.url && audioPath != null) {
      final response = await http.get(Uri.parse(audioPath));
      final tempDir = await getTemporaryDirectory();
      audioFile = File('${tempDir.path}/url_audio.mp3');
      // Save the audio data from the URL to a temporary file.
      await audioFile.writeAsBytes(response.bodyBytes);
    }
    // Handle the case where the audio file is already on the device (direct file).
    else if (audioType == AudioType.directFile && audioPath != null) {
      audioFile = File(audioPath);
    }

    // If the audio file is successfully created or loaded, extract the waveform.
    if (audioFile != null) {
      List<double> waves = await extrectWaveform(audioFile);
      return waves;
    }

    // Return an empty list if the audio file could not be processed.
    return [];
  } catch (e) {
    // In case of error, return an empty list.
    return [];
  }
}
