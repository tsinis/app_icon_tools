import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';

// import '../locator.dart';
// import '../services/navigation_service.dart';
// import '../ui/preview_screen.dart';
// import '../ui/router.dart';

class UploadFile with ChangeNotifier {
  Image recivedImage;

  // final NavigationService _navigationService = locator<NavigationService>();

  Future<bool> checkImage(dynamic _uploadedFile) async {
    print('$_uploadedFile is being checked');
    try {
      // if (_uploadedFile is Image) {
      //   print('Its an Image');
      //   if (_extensionIsPng(_uploadedFile.semanticLabel)) {
      //     recivedImage = _uploadedFile;
      //     print('Its an Image and converted');
      //     return true;
      //   } else {
      //     print('Its not a PNG Image');
      //     return false;
      //   }
      // } else
      if (_uploadedFile is File) {
        print('Its a File');
        if (_extensionIsPng(_uploadedFile.name)) {
          print('Its a PNG');
          await _convertFileToImage(_uploadedFile)
              .then((_convertedImage) => recivedImage = _convertedImage)
              .whenComplete(() {
            print('Converted');
            return true;
          });
          // await _navigationService.navigateTo(UiRouter.previewRoute);
        } else {
          print('not PNG');
          return false;
        }
      }
      return false;
      // ignore: avoid_catching_errors
    } on Error catch (_) {
      return false;
    }
  }

  Future<Image> _convertFileToImage(File _file) async =>
      await _convertHtmlFileToBytes(_file).then((_uint8list) => Image.memory(_uint8list));

  Future<Uint8List> _convertHtmlFileToBytes(File _htmlFile) async {
    final Completer<Uint8List> _bytesCompleter = Completer<Uint8List>();
    final FileReader reader = FileReader();
    reader.onLoadEnd.listen((event) {
      final Uint8List _bytes = const Base64Decoder().convert(reader.result.toString().split(',').last);
      _bytesCompleter.complete(_bytes);
    });
    reader.readAsDataUrl(_htmlFile);
    return _bytesCompleter.future;
  }

  bool _extensionIsPng(String _fileName) {
    if (_fileName.length >= 4) {
      return _fileName.substring(_fileName.length - 4).toUpperCase() == '.PNG';
    } else {
      return false;
    }
  }
}
