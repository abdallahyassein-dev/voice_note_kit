import 'dart:html' as html;
import 'dart:async';

/// Returns the URL of a blob object created from the provided audio path.
Future<String> getBlobUrl(String audioPath) async {
  final response = await html.HttpRequest.request(
    audioPath,
    responseType: 'blob',
  );
  final blob = response.response as html.Blob;

  final objectUrl = html.Url.createObjectUrlFromBlob(blob);
  return objectUrl;
}
