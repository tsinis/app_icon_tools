import 'dart:async';
import 'dart:io' as io;
import 'dart:math' show max;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:image_resizer/image_resizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_info/platform_info.dart';
import 'package:share/share.dart';
import 'package:universal_html/html.dart' as html;

import '../extensions/image_resizer_package/android_adaptive.dart';
import '../extensions/image_resizer_package/constants/android_regular.dart';
import '../extensions/image_resizer_package/constants/web.dart';
import '../extensions/image_resizer_package/pwa.dart';
import '../extensions/image_resizer_package/windows.dart';
import '../generated/l10n.dart';
import '../locator.dart';
import '../services/navigation_service.dart';
import '../services/router.dart';

class SetupIcon extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();

  void devicePreview() => _navigationService.navigateTo(UiRouter.deviceScreen);
  void initialScreen() => _navigationService.navigateTo(UiRouter.initialScreen);
  void setupScreen() => _navigationService.navigateTo(UiRouter.setupScreen);
  void goBack() => _navigationService.goBack();

  Color _backgroundColor;
  Color get backgroundColor => _backgroundColor;
  void setBackgroundColor(Color _newColor) {
    if (_backgroundColor != _newColor) {
      _backgroundColor = _newColor;
      _adaptiveColor ??= _newColor.withAlpha(255);
      notifyListeners();
    }
  }

  void removeColor() {
    _backgroundColor = null;
    notifyListeners();
  }

  Uint8List _icon = Uint8List(0), _adaptiveBackground, _adaptiveForeground;

  Image get iconImage => Image.memory(_icon);
  Uint8List get regularIcon => _icon;
  set regularIcon(Uint8List _uploadedPng) {
    if (_uploadedPng != _icon && _uploadedPng != null) {
      _icon = _uploadedPng;
      _regularIconFiles.clear();
      _adaptiveIconFiles.clear();
      _pwaConfigs.clear();
      _xmlConfigs.clear();
      _bgIssues.clear();
      _fgIssues.clear();
      notifyListeners();
    }
  }

  // Adaptive Icon Background as COLOR.
  Color _adaptiveColor;
  Color get adaptiveColor => _adaptiveColor;
  void setAdaptiveColor(Color _newColor) {
    if (_adaptiveColor != _newColor) {
      _adaptiveColor = _newColor;
      if (_newColor != null) {
        _backgroundColor ??= _newColor.withAlpha(255);
      }
      notifyListeners();
    }
  }

  void removeAdaptiveColor() {
    _adaptiveColor = null;
    notifyListeners();
  }

  bool get haveAdaptiveColor => _adaptiveColor != null;

  bool _preferColorBg = false;
  bool get preferColorBg => _preferColorBg;
  void switchBg({@required bool preferColor}) {
    _preferColorBg = preferColor;
    notifyListeners();
  }

  // Adaptive Icon Background as IMAGE.
  Uint8List get adaptiveBackground => _adaptiveBackground;
  set adaptiveBackground(Uint8List _uploadedPng) {
    if (_uploadedPng != _adaptiveBackground && _uploadedPng != null) {
      // if (_adaptiveBackground.isNotEmpty) {
      //   _adaptiveBackground.clear();
      // }
      _adaptiveBackground = _uploadedPng;
      _adaptiveIconFiles.clear();
      notifyListeners();
    }
  }

  bool get haveAdaptiveBackground => _adaptiveBackground != null;
  void removeAdaptiveBackground() {
    _adaptiveBackground = null;
    _bgIssues.clear();
    notifyListeners();
  }

  Uint8List get adaptiveForeground => _adaptiveForeground;
  set adaptiveForeground(Uint8List _uploadedPng) {
    if (_uploadedPng != _adaptiveForeground && _uploadedPng != null) {
      _adaptiveForeground = _uploadedPng;
      _adaptiveIconFiles.clear();
      notifyListeners();
    }
  }

  bool get haveAdaptiveForeground => _adaptiveForeground != null;
  void removeadaptiveForeground() {
    _adaptiveForeground = null;
    _fgIssues.clear();
    notifyListeners();
  }

  bool get _exportingAdaptiveFiles =>
      exportAdaptive &&
      (haveAdaptiveForeground && ((haveAdaptiveBackground && !preferColorBg) || (haveAdaptiveColor && preferColorBg)));

  final Set<String> _fgIssues = {}, _bgIssues = {}, _iconIssues = {};

  Set<String> get foregroundIssues => _fgIssues;
  set foregroundIssues(Set<String> detectedIssues) {
    if (_fgIssues != detectedIssues) {
      _fgIssues
        ..clear()
        ..addAll(detectedIssues);
      // notifyListeners();
    }
  }

  Set<String> get backgroundIssues => _bgIssues;
  set backgroundIssues(Set<String> detectedIssues) {
    if (_bgIssues != detectedIssues) {
      _bgIssues
        ..clear()
        ..addAll(detectedIssues);
      // notifyListeners();
    }
  }

  Set<String> get iconIssues => _iconIssues;
  set iconIssues(Set<String> detectedIssues) {
    if (_iconIssues != detectedIssues) {
      _iconIssues
        ..clear()
        ..addAll(detectedIssues);
      // notifyListeners();
    }
  }

  String get issues {
    String _iconMsg = '', _fgMsg = '', _bgMsg = '';
    if (_iconIssues.isNotEmpty) {
      _iconMsg = _stringIssues();
    }
    if (_fgIssues.isNotEmpty) {
      _fgMsg = _stringIssues(where: _foreground);
    }
    if (_bgIssues.isNotEmpty) {
      _bgMsg = _stringIssues(where: _background);
    }
    return _iconMsg + _fgMsg + _bgMsg;
  }

  static const String _foreground = 'foreground', _background = 'background';

  String _stringIssues({String where = 'icon'}) {
    final StringBuffer _msgBuffer = StringBuffer();
    switch (where) {
      case _background:
        {
          _msgBuffer..write('\n\n')..write(S.current.adaptiveBackground);
          for (final String _Issue in _bgIssues) {
            _msgBuffer..write('\n')..write(_Issue);
          }
          break;
        }
      case _foreground:
        {
          _msgBuffer..write('\n\n')..write(S.current.adaptiveForeground);
          for (final String _Issue in _fgIssues) {
            _msgBuffer..write('\n')..write(_Issue);
          }
          if (!_fgIssues.contains(_info) && exportAdaptive) {
            _msgBuffer..write('\n')..write(S.current.transparencyAdaptive);
          }
          break;
        }
      default:
        {
          _msgBuffer..write('\n\n')..write(S.current.regularIcon);
          for (final String _Issue in _iconIssues) {
            _msgBuffer..write('\n')..write(_Issue);
          }
          if (_iconIssues.contains(_info) && (exportIOS || exportWeb)) {
            _msgBuffer..write('\n')..write(S.current.transparencyIOS);
          }
          break;
        }
    }
    return _msgBuffer.toString();
  }

  static final String _info = S.current.isTransparent;

  double get hue {
    final int _iconIssuesCount = _iconIssues.length - (_iconIssues.contains(_info) ? 1 : 0);
    final int _foregroundIssuesCount = _fgIssues.length - (_fgIssues.contains(_info) ? 1 : 0);
    final int _backgroundIssuesCount = _bgIssues.length - (_bgIssues.contains(_info) ? 1 : 0);
    return max(0, 70 - (17.5 * _iconIssuesCount) - (17.5 * _foregroundIssuesCount) - (17.5 * _backgroundIssuesCount));
  }

  double _iconShapeRadius = 25;
  double get cornerRadius => _iconShapeRadius;
  void setRadius(double _newRadius) {
    if (_newRadius != _iconShapeRadius) {
      _iconShapeRadius = _newRadius;
      notifyListeners();
    }
  }

  int _platformID = 0;
  int get platformID => _platformID;
  void setPlatform(int _selectedPlatform) {
    if (_selectedPlatform != _platformID) {
      {
        _platformID = _selectedPlatform ?? 1;
        notifyListeners();
      }
    }
  }

  final Map<String, List<FileData>> _regularIconFiles = {}, _adaptiveIconFiles = {}, _xmlConfigs = {}, _pwaConfigs = {};

  Future archive() async {
    _exportedDoneCount = 0;
    _setLoading(true);
    final IconGenerator _gen = IconGenerator();
    final List<FileData> _files = [];
    Future<void>.delayed(
        //TODO! Check when https://github.com/flutter/flutter/issues/33577 is closed.
        const Duration(milliseconds: kIsWeb ? 300 : 0),
        () async => await _resizeIcons().whenComplete(() async {
              for (final key in _regularIconFiles.keys) {
                final List<FileData> _folder = _regularIconFiles[key];
                _files.addAll(_folder.toList());
              }
              if (_exportingAdaptiveFiles) {
                for (final key in _adaptiveIconFiles.keys) {
                  final List<FileData> _adaptiveFolder = _adaptiveIconFiles[key];
                  _files.addAll(_adaptiveFolder.toList());
                }
                _generateXmlConfigs();
                for (final key in _xmlConfigs.keys) {
                  final List<FileData> _txtFolder = _xmlConfigs[key];
                  _files.addAll(_txtFolder.toList());
                }
              }
              if (exportWeb) {
                _generatePwaConfigs();
                for (final key in _pwaConfigs.keys) {
                  final List<FileData> _txtFolder = _pwaConfigs[key];
                  _files.addAll(_txtFolder.toList());
                }
              }
              // print('Images: ${_images.length}');
              final List<int> _data = _gen.generateArchive(_files);
              await _saveFile('icons.zip', binaryData: _data).then((_exported) {
                if (_exported) {
                  _countDown = 0;
                  _exportedDoneCount = 100;
                  _loading = false;
                  _showSnackInfo();
                }
              });
            }));
  }

  int _countDown = 0;
  int get countDown => _countDown;

  void _showSnackInfo() {
    _exportedDoneCount = 0;
    Timer.periodic(const Duration(milliseconds: 50), (Timer _timer) {
      if (_countDown > 99) {
        _countDown = 0;
        _timer.cancel();
      } else {
        _countDown = _countDown + 1;
      }
      notifyListeners();
    });
  }

  // Future<String> get _tempDirectory async {
  //   if (platform.isMobile) {
  //     final io.Directory _dir = await getTemporaryDirectory();
  //     return _dir.path;
  //   } else {
  //     return '';
  //   }
  // }

  Future<String> get _getSaveDirectory async {
    io.Directory _dir;
    if (platform.isAndroid) {
      _dir = await getExternalStorageDirectory();
    } else if (platform.isIOS) {
      _dir = await getApplicationDocumentsDirectory();
    } else {
      _dir = await getDownloadsDirectory();
    }
    return _dir.path;
  }

  Future<bool> _saveFile(String fileName, {@required List<int> binaryData, bool silentErrors = false}) async {
    if (kIsWeb) {
      Uri dataUrl = Uri();
      try {
        // ignore: unnecessary_null_comparison
        if (binaryData != null) {
          dataUrl = Uri.dataFromBytes(binaryData);
        }
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        if (!silentErrors) {
          throw Exception('Error Creating File Data on Web: $e');
        }
        return false;
      }
      html.AnchorElement()
        ..href = dataUrl.toString()
        ..setAttribute('download', fileName)
        ..click();
    } else {
      try {
        await _getSaveDirectory.then((_path) async {
          io.File('$_path/$fileName')
            ..createSync()
            ..writeAsBytesSync(binaryData);
          if (platform.isMobile) {
            await Share.shareFiles(['$_path/$fileName'], mimeTypes: ['application/zip']);
          }
        });
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        if (!silentErrors) {
          throw Exception('Error Creating File Data on Device: $e');
        }
        return false;
      }
    }
    return true;
  }

  bool get exportIOS => _platforms[_ios] ?? true;
  bool get exportWeb => _platforms[_web] ?? true;
  bool get exportAdaptive => _platforms[_androidAdapt] ?? true;

  int get _toExportCount =>
      (_exportingAdaptiveFiles ? 2 : 1) + _platforms.values.where((_willBeExported) => true).length ?? 1;
  num get exportProgress => 100 * (_exportedDoneCount / _toExportCount).clamp(0, 1);
  int _exportedDoneCount = 0;
  bool _loading = false;
  bool get loading => _loading;
  void _setLoading(bool newValue) {
    _loading = newValue;
    notifyListeners();
  }

  Future _resizeIcons() async {
    if (_regularIconFiles.isEmpty) {
      // if (_platforms[_linux] ?? true) {
      //   await _generatePngIcons('linux', WebIconsFolder());
      // }
      // if (_platforms[_fuchsiaOS] ?? true) {
      //   await _generatePngIcons('fos', WebIconsFolder());
      // }
      if (_platforms[_web] ?? true) {
        await _generatePngIcons('web', WebIconsFolder(path: 'web', icons: webIcons));
      }
      if (_platforms[_ios] ?? true) {
        await _generatePngIcons('iOS', IosIconsFolder());
      }
      if (_platforms[_macOS] ?? true) {
        await _generatePngIcons('macOS', MacOSIconsFolder());
      }
      if (_platforms[_windows] ?? true) {
        await _generateIcoIcon(WindowsIconsFolder());
      }
      if (_platforms[_androidReg] ?? true) {
        await _generatePngIcons('droid', AndroidIconsFolder(icons: androidRegular));
      }
    } else {
      _exportedDoneCount = _toExportCount - (_exportingAdaptiveFiles ? 3 : 2);
      notifyListeners();
    }
    if (_adaptiveIconFiles.isEmpty) {
      if (_exportingAdaptiveFiles) {
        if (!preferColorBg) {
          await _generateAdaptiveIcons(BackgroundIconsFolder());
        }
        await _generateAdaptiveIcons(ForegroundIconsFolder());
      }
    } else {
      _exportedDoneCount = _toExportCount - 1;
      notifyListeners();
    }
  }

  void _generateXmlConfigs({String key = 'xml'}) {
    final XmlGenerator _gen =
        XmlGenerator(bgAsColor: preferColorBg, color: adaptiveColor ?? backgroundColor ?? const Color(0xFF000000));
    final List<FileData> _archive = _gen.generateXmls();
    _xmlConfigs[key] = _archive;
    _exportedDoneCount = _exportedDoneCount + 1;
    notifyListeners();
  }

  void _generatePwaConfigs({String key = 'pwa'}) {
    final PwaConfigGenerator _gen = PwaConfigGenerator(color: backgroundColor ?? const Color(0xFF000000));
    final List<FileData> _archive = _gen.generatePwaConfigs();
    _pwaConfigs[key] = _archive;
  }

  Future _generatePngIcons(String key, ImageFolder folder) async {
    final img.Image _image = img.decodePng(_icon);
    final IconGenerator _gen = IconGenerator();
    // final String _pathToTempDir = await _tempDirectory;
    final List<FileData> _archive =
        await _gen.generateIcons(_image, folder, writeToDiskIO: !platform.isWeb && platform.isDesktop);
    _regularIconFiles[key] = _archive;
    _exportedDoneCount = _exportedDoneCount + 1;
    notifyListeners();
  }

  Future _generateAdaptiveIcons(ImageFolder folder) async {
    final bool _background = folder is BackgroundIconsFolder;
    final String _key = _background ? 'bg' : 'fg';
    final img.Image _image = img.decodePng(_background ? _adaptiveBackground : _adaptiveForeground);
    final IconGenerator _gen = IconGenerator();
    // final String _pathToTempDir = await _tempDirectory;
    final List<FileData> _archive =
        await _gen.generateIcons(_image, folder, writeToDiskIO: !platform.isWeb && platform.isDesktop);
    _adaptiveIconFiles[_key] = _archive;
    _exportedDoneCount = _exportedDoneCount + 1;
    notifyListeners();
  }

  Future _generateIcoIcon(ImageFolder folder, {String key = 'win'}) async {
    final img.Image _image = img.decodePng(_icon);
    final List<FileData> _archive = await generateWinIcos(_image, folder, writeToDiskIO: !kIsWeb);
    _regularIconFiles[key] = _archive;
    _exportedDoneCount = _exportedDoneCount + 1;
    notifyListeners();
  }

  static const String _androidReg = 'Android Regular',
      _androidAdapt = 'Android Adaptive',
      _ios = 'Apple iOS',
      _web = 'Web (PWA)',
      _windows = 'MS Windows',
      _macOS = 'Apple macOS'
      // _linux = 'Linux', _fuchsiaOS = 'Fuchsia OS'
      ;

  final Map<String, bool> _platforms = {
    _androidReg: true,
    _androidAdapt: true,
    _ios: true,
    _web: true,
    _windows: true,
    _macOS: true,
    // _linux: true,
    // _fuchsiaOS: true,
  };
  Map<String, bool> get platforms => _platforms;
  void switchPlatform({@required String platformNameKey, @required bool isExported}) {
    _regularIconFiles.clear();
    _platforms[platformNameKey] = isExported;
    notifyListeners();
  }
}
