// Format Durations to MM:SS
String formatDuration(Duration duration) {
  final minutes = duration.inMinutes.toString().padLeft(2, '0');
  final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return "$minutes:$seconds";
}

// Format Durations From Seconds to MM:SS
String formatDurationSeconds(int seconds) {
  final mins = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return "$mins:$secs";
}
