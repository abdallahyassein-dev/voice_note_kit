// file_utils_io.dart
import 'package:path_provider/path_provider.dart';

/// Returns a temporary file path for an audio file with `.m4a` extension.
///
/// The path is generated inside the system's temporary directory and
/// includes a timestamp to ensure uniqueness.
///
/// Example output:
/// `/data/user/0/com.example.app/cache/1659271932783.m4a`
///
/// This can be useful for saving recordings or temporary audio files.
Future<String> getTempFilePath() async {
  final dir = await getTemporaryDirectory();
  return '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
}
