import 'dart:async';
import 'dart:convert';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image/image.dart' as img;

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_html/prefer_universal/html.dart';

import '../generated/l10n.dart';
import '../locator.dart';
import '../services/navigation_service.dart';
import '../services/router.dart';

//TODO Move file checking to services.

class UploadFile extends ChangeNotifier {
  static const int minIconSize = 1024;
  static const int minAdaptiveSize = 432;
  static const String expectedFileExtension = 'png';
  static const FileTypeCross _fileType = kIsWeb ? FileTypeCross.image : FileTypeCross.custom;
  Uint8List _recivedIcon = Uint8List(0), _recivedForeground, _recivedBackground;
  Uint8List get recivedIcon => _recivedIcon;
  Uint8List get recivedForeground => _recivedForeground;
  Uint8List get recivedBackground => _recivedBackground;

  bool _isValidFile = true;
  bool get isValidFile => _isValidFile;

  Future checkSelected({bool background = false, bool foreground = false}) async {
    try {
      //TODO Check condition for type on Windows/Linux, since custom file extension is not working on some platforms yet.
      await FilePickerCross.importFromStorage(type: _fileType, fileExtension: expectedFileExtension)
          .then<void>((selectedFile) => _checkFile(selectedFile, background: background, foreground: foreground));
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      // ignore: avoid_print
      print('Seems like User have cancled selection: $error');
    }
  }

  Future checkDropped(dynamic droppedFile, {bool background = false, bool foreground = false}) async =>
      await _checkFile(droppedFile, background: background, foreground: foreground);

  Future _checkFile(dynamic uploadedFile, {@required bool background, @required bool foreground}) async {
    if (!_loading) {
      _recivedBackground = _recivedForeground = null;
      _setLoading(isLoading: true, isValidFile: true);
      //TODO! Check when https://github.com/flutter/flutter/issues/33577 is closed.
      Future.delayed(const Duration(milliseconds: kIsWeb ? 300 : 0), () async {
        Uint8List rawBytes;
        try {
          if (uploadedFile is File) {
            if (_properExtension(uploadedFile.name)) {
              await _convertHtmlFileToBytes(uploadedFile).then((convertedBytes) => rawBytes = convertedBytes);
            } else {
              _setLoading(isLoading: false);
              return;
            }
          }
          if (uploadedFile is FilePickerCross) {
            if (_properExtension(uploadedFile.fileName)) {
              rawBytes = uploadedFile.toUint8List();
            } else {
              _setLoading(isLoading: false);
              return;
            }
          }
          // ignore: unnecessary_null_comparison
          if (rawBytes != null) {
            _isValidFile = _findIssues(rawBytes, foreground: foreground, background: background);
          }
          // ignore: avoid_catches_without_on_clauses
        } catch (error) {
          _setLoading(isLoading: false);
          return;
        }
        if (_isValidFile) {
          if (background) {
            _recivedBackground = rawBytes;
          } else if (foreground) {
            _recivedForeground = rawBytes;
          } else {
            _recivedIcon = rawBytes;
          }
        }

        _setLoading(isLoading: false, isValidFile: _isValidFile);
        if (!background && !foreground) {
          await _showSuccess();
        }
      });
    }
  }

  Future _showSuccess() async {
    if (_isValidFile) {
      _done = true;
      notifyListeners();
      Future<void>.delayed(const Duration(milliseconds: 2400), () async {
        await locator<NavigationService>().navigateTo(UiRouter.setupScreen);
        _done = false;
      });
    }
  }

  // Future<Image> _convertFileToImage(File uploadedFile) async =>
  //     await _convertHtmlFileToBytes(uploadedFile).then((_uint8list) => Image.memory(_uint8list));

  Future<Uint8List> _convertHtmlFileToBytes(File htmlFile) async {
    final Completer<Uint8List> bytesCompleter = Completer<Uint8List>();
    final FileReader reader = FileReader();
    reader.onLoadEnd.listen((_) {
      final Uint8List decodedBytes = const Base64Decoder().convert(reader.result.toString().split(',').last);
      bytesCompleter.complete(decodedBytes);
    });
    reader.readAsDataUrl(htmlFile);
    return bytesCompleter.future;
  }

  bool _properExtension(String fileName) {
    if (fileName.length >= 4) {
      return fileName.substring(fileName.length - 4).toLowerCase() == '.$expectedFileExtension';
    } else {
      return false;
    }
  }

  bool _findIssues(Uint8List uploadedFile, {@required bool foreground, @required bool background}) {
    final bool adaptive = foreground || background;
    final bool tooHeavy = uploadedFile.buffer.lengthInBytes / 1000 > 1024;
    final img.Image imageFile = img.decodePng(uploadedFile);
    final bool notSquare = imageFile.width != imageFile.height;
    final bool tooSmall = (imageFile.width < (adaptive ? minAdaptiveSize : minIconSize)) ||
        (imageFile.height < (adaptive ? minAdaptiveSize : minIconSize));
    final bool isTransparent = imageFile.channels == img.Channels.rgba;

    final Map<String, bool> _issuesMap = {
      S.current.tooSmall: tooSmall,
      S.current.tooHeavy: tooHeavy,
      S.current.notSqaure: notSquare,
      S.current.isTransparent: isTransparent
    };

    if (foreground) {
      _foregroundIssues.addAll(_issuesMap.keys.where((key) => _issuesMap[key] ?? false).toSet());
    } else if (background) {
      _backgroundIssues.addAll(_issuesMap.keys.where((key) => _issuesMap[key] ?? false).toSet());
    } else {
      _backgroundIssues.clear();
      _foregroundIssues.clear();
      _iconIssues.addAll(_issuesMap.keys.where((key) => _issuesMap[key] ?? false).toSet());
    }

    return true;
  }

  final Set<String> _foregroundIssues = {}, _backgroundIssues = {}, _iconIssues = {};
  Set<String> get detectedFgIssues => _foregroundIssues;
  Set<String> get detectedBgIssues => _backgroundIssues;
  Set<String> get detectedIconIssues => _iconIssues;

  bool _loading = false;
  bool get loading => _loading;
  void _setLoading({@required bool isLoading, bool isValidFile = false}) {
    _loading = isLoading;
    _isValidFile = isValidFile;
    notifyListeners();
  }

  bool _done = false;
  bool get done => _done;

// TODO Consider use another package for permission handling, since the one provided with file_picker package is somehow limited.
// Future _checkPermissions() async {
//   final PermissionStatus mobilePermissions = await Permission.storage.status ?? PermissionStatus.undetermined;
//   if (mobilePermissions.isUndetermined) {
//     await Permission.storage.request().then<void>((PermissionStatus status) async {
//       if (status == PermissionStatus.granted) {
//         return;
//       } else {
//         await Permission.storage.shouldShowRequestRationale;
//       }
//     });
//   } else if (mobilePermissions.isGranted) {
//     return;
//   } else if (mobilePermissions.isDenied) {
//     await Permission.storage.shouldShowRequestRationale;
//   } else {
//     await openAppSettings();
// }
// }
}
