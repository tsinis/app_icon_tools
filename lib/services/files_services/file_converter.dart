import 'dart:async';
import 'dart:convert';
import 'dart:typed_data' show Uint8List;
import 'package:universal_html/prefer_universal/html.dart';

// Future<Image> _convertFileToImage(File uploadedFile) async =>
//     await _convertHtmlFileToBytes(uploadedFile).then((_uint8list) => Image.memory(_uint8list));

Future<Uint8List> convertHtmlFileToBytes(File htmlFile) async {
  final Completer<Uint8List> bytesCompleter = Completer<Uint8List>();
  final FileReader reader = FileReader();
  reader.onLoadEnd.listen((_) {
    final Uint8List decodedBytes = const Base64Decoder().convert(reader.result.toString().split(',').last);
    bytesCompleter.complete(decodedBytes);
  });
  reader.readAsDataUrl(htmlFile);
  return bytesCompleter.future;
}
