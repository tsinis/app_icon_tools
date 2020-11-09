import 'dart:async';
import 'dart:convert';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image/image.dart' as img;

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_html/prefer_universal/html.dart';

import '../locator.dart';
import '../services/navigation_service.dart';
import '../services/router.dart';

class UploadFile extends ChangeNotifier {
  static const int minIconSize = 1024;
  static const int minAdaptiveSize = 432;
  static const String expectedFileExtension = 'png';
  Uint8List _recivedIcon = Uint8List(0), _recivedForeground, _recivedBackground;

  Uint8List get recivedIcon => _recivedIcon;
  Uint8List get recivedForeground => _recivedForeground;
  Uint8List get recivedBackground => _recivedBackground;

  bool _isValidFile = true;

  bool get isValidFile => _isValidFile;

  Future checkSelected({bool background = false, bool foreground = false}) async =>
      await FilePickerCross.importFromStorage(type: FileTypeCross.image, fileExtension: expectedFileExtension)
          .then<void>((_selectedFile) => _checkFile(_selectedFile, background: background, foreground: foreground));

  Future checkDropped(dynamic _droppedFile, {bool background = false, bool foreground = false}) async =>
      await _checkFile(_droppedFile, background: background, foreground: foreground);

  Future _checkFile(dynamic _file, {@required bool background, @required bool foreground}) async {
    _recivedBackground = _recivedForeground = null;
    _setLoading(true);
    //TODO! Check when https://github.com/flutter/flutter/issues/33577 is closed.
    Future<void>.delayed(
      const Duration(milliseconds: kIsWeb ? 300 : 0),
      () async {
        Uint8List _bytes;
        try {
          if (_file is File) {
            if (_properExtension(_file.name)) {
              await _convertHtmlFileToBytes(_file).then((_convertedBytes) => _bytes = _convertedBytes);
            } else {
              _setLoading(false);
              return;
            }
          }
          if (_file is FilePickerCross) {
            if (_properExtension(_file.fileName)) {
              _bytes = _file.toUint8List();
            } else {
              _setLoading(false);
              return;
            }
          }
          // ignore: unnecessary_null_comparison
          if (_bytes != null) {
            _isValidFile = _findIssues(_bytes, foreground: foreground, background: background);
          }
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          _isValidFile = false;
        }
        if (_isValidFile) {
          if (background) {
            _recivedBackground = _bytes;
          } else if (foreground) {
            _recivedForeground = _bytes;
          } else {
            _recivedIcon = _bytes;
          }
        }

        _setLoading(false);
        if (!background && !foreground) {
          await _navigateToSetup();
        }
      },
    );
  }

  Future<void> _navigateToSetup() async {
    if (_isValidFile) {
      await locator<NavigationService>().navigateTo(UiRouter.setupScreen);
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
      return _fileName.substring(_fileName.length - 4).toLowerCase() == '.$expectedFileExtension';
    } else {
      return false;
    }
  }

  bool _findIssues(Uint8List _file, {@required bool foreground, @required bool background}) {
    final bool _adaptive = foreground || background;
    final bool _tooHeavy = _file.buffer.lengthInBytes / 1000 > 1024;
    final img.Image _image = img.decodePng(_file);
    final bool _notSquare = _image.width != _image.height;
    final bool _tooSmall = (_image.width < (_adaptive ? minAdaptiveSize : minIconSize)) ||
        (_image.height < (_adaptive ? minAdaptiveSize : minIconSize));
    final bool _isTransparent = _image.channels == img.Channels.rgba;

    final Map<int, bool> _issuesMap = {0: _tooSmall, 1: _tooHeavy, 2: _notSquare, 3: _isTransparent};

    if (foreground) {
      _foregroundIssues
        ..clear()
        ..addAll(_issuesMap);
    } else if (background) {
      _backgroundIssues
        ..clear()
        ..addAll(_issuesMap);
    } else {
      _backgroundIssues.clear();
      _foregroundIssues.clear();
      _iconIssues
        ..clear()
        ..addAll(_issuesMap);
    }

    return true;
  }

  final Map<int, bool> _iconIssues = {}, _foregroundIssues = {}, _backgroundIssues = {};

  Map<int, bool> get iconIssues => _iconIssues;
  Map<int, bool> get foregroundIssues => _foregroundIssues;
  Map<int, bool> get backgroundIssues => _backgroundIssues;

  bool _loading = false;
  bool get loading => _loading;
  void _setLoading(bool newValue) {
    _loading = newValue;
    notifyListeners();
  }
}
