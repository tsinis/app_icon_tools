import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:platform_info/platform_info.dart';

Future<String> getSaveDirectory() async {
  Directory platformSpecificDir;
  if (platform.isAndroid) {
    platformSpecificDir = await getExternalStorageDirectory();
  } else if (platform.isIOS) {
    platformSpecificDir = await getApplicationDocumentsDirectory();
  } else {
    platformSpecificDir = await getDownloadsDirectory();
  }
  return platformSpecificDir.path;
}

// Future<String> get tempDirectory async {
//   if (platform.isMobile) {
//     final Directory dir = await getTemporaryDirectory();
//     return dir.path;
//   } else {
//     return '';
//   }
// }
