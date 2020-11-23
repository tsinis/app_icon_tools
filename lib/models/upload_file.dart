import 'dart:async';
import 'dart:typed_data' show Uint8List;

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:universal_html/prefer_universal/html.dart';

import '../constants/default_non_null_values.dart';
import '../constants/files_properties.dart';
import '../generated/l10n.dart';
import '../locator_dependency_injection.dart';
import '../services/files_services/file_converter.dart';
import '../services/files_services/file_extension_checker.dart';
import '../services/navigation_service.dart';
import '../services/router.dart';

class UploadFile extends ChangeNotifier {
  static const FileTypeCross _fileType = kIsWeb ? FileTypeCross.image : FileTypeCross.custom;

  final Set<String> _backgroundIssues = {}, _foregroundIssues = {}, _iconIssues = {};
  bool _done = false, _isValidFile = true, _loading = false;
  Uint8List _recivedIcon = NullSafeValues.zeroBytes,
      _recivedForeground = NullSafeValues.zeroBytes,
      _recivedBackground = NullSafeValues.zeroBytes;

  Uint8List get recivedIcon => _recivedIcon;

  Uint8List get recivedForeground => _recivedForeground;

  Uint8List get recivedBackground => _recivedBackground;

  bool get isValidFile => _isValidFile;

  Future checkSelected({bool background = false, bool foreground = false}) async {
    try {
      //TODO! Check condition for type on Windows/Linux, since custom file extension is not working on some platforms yet.
      await FilePickerCross.importFromStorage(type: _fileType, fileExtension: FilesProperties.expectedFileExtension)
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
      _recivedBackground = _recivedForeground = NullSafeValues.zeroBytes;
      _setLoading(isLoading: true, isValidFile: true);
      //TODO Check when https://github.com/flutter/flutter/issues/33577 is closed.
      Future.delayed(const Duration(milliseconds: kIsWeb ? 300 : 0), () async {
        Uint8List rawBytes = NullSafeValues.zeroBytes;
        try {
          if (uploadedFile is File) {
            if (properExtension(uploadedFile.name)) {
              await convertHtmlFileToBytes(uploadedFile).then((convertedBytes) => rawBytes = convertedBytes);
            } else {
              _setLoading(isLoading: false);
              return;
            }
          }
          if (uploadedFile is FilePickerCross) {
            if (properExtension(uploadedFile.fileName)) {
              rawBytes = uploadedFile.toUint8List();
            } else {
              _setLoading(isLoading: false);
              return;
            }
          }
          if (rawBytes != NullSafeValues.zeroBytes) {
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
      Future<void>.delayed(const Duration(milliseconds: 2400), () {
        locator<NavigationService>().navigateTo(UiRouter.setupScreen);
        _done = false;
      });
    }
  }

  bool _findIssues(Uint8List uploadedFile, {@required bool foreground, @required bool background}) {
    try {
      final Map<String, bool> _issuesMap =
          _checkedIssues(fileToCheck: uploadedFile, isAdaptive: foreground || background);
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
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      // ignore: avoid_print
      print('Looks like the file is not an PNG, for example, it may be a renamed JPG.\nError: $error');
      return false;
    }
  }

  Map<String, bool> _checkedIssues({@required Uint8List fileToCheck, @required bool isAdaptive}) {
    final bool tooHeavy = fileToCheck.buffer.lengthInBytes / 1000 > FilesProperties.maxFileSizeKB;
    final img.Image imageFile = img.decodePng(fileToCheck);
    final bool notSquare = imageFile.width != imageFile.height;
    final bool tooSmall =
        (imageFile.width < (isAdaptive ? FilesProperties.minAdaptiveSize : FilesProperties.minIconSize)) ||
            (imageFile.height < (isAdaptive ? FilesProperties.minAdaptiveSize : FilesProperties.minIconSize));
    final bool isTransparent = imageFile.channels == img.Channels.rgba;
    return {
      S.current.tooSmall: tooSmall,
      S.current.tooHeavy: tooHeavy,
      S.current.notSqaure: notSquare,
      S.current.isTransparent: isTransparent
    };
  }

  Set<String> get detectedFgIssues => _foregroundIssues;

  Set<String> get detectedBgIssues => _backgroundIssues;

  Set<String> get detectedIconIssues => _iconIssues;

  bool get loading => _loading;

  void _setLoading({@required bool isLoading, bool isValidFile = false}) {
    _loading = isLoading;
    _isValidFile = isValidFile;
    notifyListeners();
  }

  bool get done => _done;
}
