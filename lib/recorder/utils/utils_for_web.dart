// file_utils_stub.dart
String getTempFileForWeb() {
  // Web: Just return a dummy file name
  return '${DateTime.now().millisecondsSinceEpoch}.m4a';
}
