import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data' show Uint8List;

import 'package:file_picker_platform_interface/file_picker_platform_interface.dart' show FileType;
import 'package:file_picker_web/file_picker_web.dart';
import 'package:flutter/widgets.dart';

import '../locator.dart';
import '../services/navigation_service.dart';
import '../ui/router.dart';

class UploadFile extends ChangeNotifier {
  Image recivedImage, recivedForeground, recivedBackground;

  static const String _expectedFileExtension = 'png';

  final NavigationService _navigationService = locator<NavigationService>();

  bool _isProperFile = true;

  bool get isProperFile => _isProperFile;

  Future checkSelected({bool background = false, bool foreground = false}) async =>
      await FilePicker.getFile(type: FileType.custom, allowedExtensions: [_expectedFileExtension])
          .then<void>((_selectedFile) => _checkFile(_selectedFile, background: background, foreground: foreground));

  Future checkDropped(dynamic _droppedFile, {bool background = false, bool foreground = false}) async =>
      await _checkFile(_droppedFile, background: background, foreground: foreground);

  Future _checkFile(dynamic _file, {bool background, bool foreground}) async {
    _isProperFile = false;
    // print('Yupee! ${_file.runtimeType} is being checked.');
    try {
      // if (_file is Image) {
      //   if (_properExtension(_file.semanticLabel)) {
      //     _isProperFile = true;
      //     recivedImage = _file;
      //   }
      // } else
      if (_file is File) {
        if (_properExtension(_file.name)) {
          await _convertFileToImage(_file).then((_convertedImage) {
            if (background) {
              recivedBackground = _convertedImage;
            } else if (foreground) {
              recivedForeground = _convertedImage;
            } else {
              recivedForeground = recivedBackground = null;
              recivedImage = _convertedImage;
            }
          }).whenComplete(() {
            // print('Converted file to image and moving to the next screen!');
            _isProperFile = true;
          });
        }
      }
      // ignore: avoid_catching_errors, unused_catch_clause
    } on Error catch (_error) {
      // print('Error was: ${_error.toString()}');

      // ignore: unused_catch_clause
    } on Exception catch (_exception) {
      // print('Exception was: ${_exception.toString()}');
    }
    if (background || foreground) {
      notifyListeners();
    } else {
      await _notifyCheckResult();
    }
  }

  Future<void> _notifyCheckResult() async {
    if (_isProperFile) {
      notifyListeners();
      await _navigationService.navigateTo(UiRouter.setupScreen);
    } else {
      notifyListeners();
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

  bool _properExtension(String _fileName) {
    if (_fileName.length >= 4) {
      return _fileName.substring(_fileName.length - 4).toLowerCase() == '.$_expectedFileExtension';
    } else {
      // print('It is not a $_expectedFileExtension');
      return false;
    }
  }
}
