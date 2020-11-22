import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:platform_info/platform_info.dart';
import 'package:share/share.dart';
import 'package:universal_html/html.dart' as html;

import '../../constants/icons_properties.dart';
import 'file_directory_getter.dart';

Future<bool> saveFile(List<int> binaryData, {bool silentErrors = false}) async {
  const String fileName = IconsProperties.archiveName;
  if (kIsWeb) {
    Uri dataUrl = Uri();
    try {
      dataUrl = Uri.dataFromBytes(binaryData);
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      if (!silentErrors) {
        throw Exception('Error Creating File Data on Web: $error');
      }
      return false;
    }
    html.AnchorElement()
      ..href = dataUrl.toString()
      ..setAttribute('download', fileName)
      ..click();
  } else {
    try {
      await getSaveDirectory().then((pathToFile) async {
        File('$pathToFile/$fileName')
          ..createSync()
          ..writeAsBytesSync(binaryData);
        if (platform.isMobile) {
          await Share.shareFiles(['$pathToFile/$fileName'], mimeTypes: ['application/zip']);
        }
      });
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      if (!silentErrors) {
        throw Exception('Error Creating File Data on Device: $error');
      }
      return false;
    }
  }
  return true;
}
