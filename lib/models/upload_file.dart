import 'dart:async';
import 'dart:convert';
import 'dart:typed_data' show Uint8List;
import 'package:image/image.dart' as img;

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_html/prefer_universal/html.dart';

import '../locator.dart';
import '../services/navigation_service.dart';
import '../services/router.dart';

class UploadFile extends ChangeNotifier {
  Uint8List recivedIcon, recivedForeground, recivedBackground;

  static const String _expectedFileExtension = 'png';

  final NavigationService _navigationService = locator<NavigationService>();

  bool _isProperFile = true;

  bool get isProperFile => _isProperFile;

  Future checkSelected({bool background = false, bool foreground = false}) async =>
      await FilePickerCross.importFromStorage(type: FileTypeCross.image, fileExtension: _expectedFileExtension)
          .then<void>((_selectedFile) => _checkFile(_selectedFile, background: background, foreground: foreground));

  Future checkDropped(dynamic _droppedFile, {bool background = false, bool foreground = false}) async =>
      await _checkFile(_droppedFile, background: background, foreground: foreground);

  Future _checkFile(dynamic _file, {bool background, bool foreground}) async {
    _isProperFile = false;
    // print('Yupee! ${_file.runtimeType} is being checked.');
    try {
      if (_file is File) {
        if (_properExtension(_file.name)) {
          await _convertHtmlFileToBytes(_file).then((_bytes) {
            if (background) {
              recivedBackground = _bytes;
            } else if (foreground) {
              recivedForeground = _bytes;
              _checkTransparency(adaptiveForeground: true);
            } else {
              recivedForeground = recivedBackground = null;
              recivedIcon = _bytes;
              _checkTransparency();
            }
            _isProperFile = true;
          });
        }
      }
      if (_file is FilePickerCross) {
        if (_properExtension(_file.fileName)) {
          if (background) {
            recivedBackground = _file.toUint8List();
          } else if (foreground) {
            recivedForeground = _file.toUint8List();
            _checkTransparency(adaptiveForeground: true);
          } else {
            recivedForeground = recivedBackground = null;
            recivedIcon = _file.toUint8List();
            _checkTransparency();
          }
          _isProperFile = true;
        }
      }
      // if (_file is FilePickerResult) {
      //   if (_properExtension(_file.names.first)) {
      //     if (background) {
      //       recivedBackground = _file.files.first.bytes;
      //     } else if (foreground) {
      //       recivedForeground = _file.files.first.bytes;
      //     } else {
      //       recivedForeground = recivedBackground = null;
      //       recivedIcon = _file.files.first.bytes;
      //     }
      //     _isProperFile = true;
      //   }
      // }
      // ignore: avoid_catching_errors, unused_catch_clause
    } on Error catch (_error) {
      // print('Error was: ${_error.toString()}');

      // ignore: unused_catch_clause
    } on Exception catch (_exception) {
      // print('Exception was: ${_exception.toString()}');
    }
    if (_isProperFile) {
      _findIssues(foreground: foreground, background: background);
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

  // Future<Image> _convertFileToImage(File _file) async =>
  //     await _convertHtmlFileToBytes(_file).then((_uint8list) => Image.memory(_uint8list));

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

  bool _transparentForeground = true;
  bool _transparentIcon = false;
  bool get transparentForeground => _transparentForeground;
  bool get transparentIcon => _transparentIcon;

  void _checkTransparency({bool adaptiveForeground = false}) {
    final img.Image _image = img.decodeImage(adaptiveForeground ? recivedForeground : recivedIcon);
    final bool _haveAlpha = _image.channels == img.Channels.rgba;
    if (adaptiveForeground) {
      _transparentForeground = _haveAlpha ?? true;
    } else {
      _transparentIcon = _haveAlpha ?? false;
      _transparentForeground = true;
    }
  }

  void _findIssues({@required bool foreground, @required bool background}) {
    // final bool _tooSmall, tooHeavy, _noTransparancy, _notSquare;
    final bool _adaptive = foreground || background;
    final img.Image _image =
        img.decodeImage(_adaptive ? (foreground ? recivedForeground : recivedBackground) : recivedIcon);
  }
}
