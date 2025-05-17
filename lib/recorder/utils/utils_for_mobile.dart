// file_utils_io.dart
import 'package:path_provider/path_provider.dart';

Future<String> getTempFilePath() async {
  final dir = await getTemporaryDirectory();
  return '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
}
