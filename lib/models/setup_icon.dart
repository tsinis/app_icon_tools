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
  void setBackgroundColor(Color newColor) {
    if (_backgroundColor != newColor) {
      _backgroundColor = newColor;
      _adaptiveColor ??= newColor.withAlpha(255);
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
  set regularIcon(Uint8List uploadedPNG) {
    if (uploadedPNG != _icon && uploadedPNG != null) {
      _icon = uploadedPNG;
      _wipeOldData();
      notifyListeners();
    }
  }

  void _wipeOldData() {
    _regularIconFiles.clear();
    _adaptiveIconFiles.clear();
    _pwaConfigs.clear();
    _xmlConfigs.clear();
    _bgIssues.clear();
    _fgIssues.clear();
  }

  // Adaptive Icon Background as COLOR.
  Color _adaptiveColor;
  Color get adaptiveColor => _adaptiveColor;
  void setAdaptiveColor(Color newColor) {
    if (_adaptiveColor != newColor) {
      _adaptiveColor = newColor;
      if (newColor != null) {
        _backgroundColor ??= newColor.withAlpha(255);
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
  void switchBgColorPreference({@required bool preferColor}) {
    _preferColorBg = preferColor;
    notifyListeners();
  }

  // Adaptive Icon Background as IMAGE.
  Uint8List get adaptiveBackground => _adaptiveBackground;
  set adaptiveBackground(Uint8List uploadedPNG) {
    if (uploadedPNG != _adaptiveBackground && uploadedPNG != null) {
      _adaptiveBackground = uploadedPNG;
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
  set adaptiveForeground(Uint8List uploadedPNG) {
    if (uploadedPNG != _adaptiveForeground && uploadedPNG != null) {
      _adaptiveForeground = uploadedPNG;
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
    }
  }

  Set<String> get backgroundIssues => _bgIssues;
  set backgroundIssues(Set<String> detectedIssues) {
    if (_bgIssues != detectedIssues) {
      _bgIssues
        ..clear()
        ..addAll(detectedIssues);
    }
  }

  Set<String> get iconIssues => _iconIssues;
  set iconIssues(Set<String> detectedIssues) {
    if (_iconIssues != detectedIssues) {
      _iconIssues
        ..clear()
        ..addAll(detectedIssues);
    }
  }

  String get issues {
    String regularIssuesText = '', foregroundIssuesText = '', backgroundIssuesText = '';
    if (_iconIssues.isNotEmpty) {
      regularIssuesText = _stringIssues();
    }
    if (_fgIssues.isNotEmpty) {
      foregroundIssuesText = _stringIssues(where: _foreground);
    }
    if (_bgIssues.isNotEmpty) {
      backgroundIssuesText = _stringIssues(where: _background);
    }
    return regularIssuesText + foregroundIssuesText + backgroundIssuesText;
  }

  static const String _foreground = 'foreground', _background = 'background';

  String _stringIssues({String where = 'icon'}) {
    final StringBuffer textInMemory = StringBuffer();
    switch (where) {
      case _background:
        {
          textInMemory..write('\n\n')..write(S.current.adaptiveBackground);
          for (final String issue in _bgIssues) {
            textInMemory..write('\n')..write(issue);
          }
          break;
        }
      case _foreground:
        {
          textInMemory..write('\n\n')..write(S.current.adaptiveForeground);
          for (final String issue in _fgIssues) {
            textInMemory..write('\n')..write(issue);
          }
          if (!_fgIssues.contains(_info) && exportAdaptive) {
            textInMemory..write('\n')..write(S.current.transparencyAdaptive);
          }
          break;
        }
      default:
        {
          textInMemory..write('\n\n')..write(S.current.regularIcon);
          for (final String issue in _iconIssues) {
            textInMemory..write('\n')..write(issue);
          }
          if (_iconIssues.contains(_info) && (exportIOS || exportWeb)) {
            textInMemory..write('\n')..write(S.current.transparencyIOS);
          }
          break;
        }
    }
    return textInMemory.toString();
  }

  static final String _info = S.current.isTransparent;

  double get hue {
    final int iconIssuesCount = _iconIssues.length - (_iconIssues.contains(_info) ? 1 : 0);
    final int fgIssuesCount = _fgIssues.length - (_fgIssues.contains(_info) ? 1 : 0);
    final int bgIssuesCount = _bgIssues.length - (_bgIssues.contains(_info) ? 1 : 0);
    return max(0, 70 - (17.5 * iconIssuesCount) - (17.5 * fgIssuesCount) - (17.5 * bgIssuesCount));
  }

  double _iconShapeRadius = 25;
  double get cornerRadius => _iconShapeRadius;
  void setRadius(double newRadius) {
    if (newRadius != _iconShapeRadius) {
      _iconShapeRadius = newRadius;
      notifyListeners();
    }
  }

  int _platformID = 0;
  int get platformID => _platformID;
  void setPlatform(int selectedPlatform) {
    if (selectedPlatform != _platformID) {
      {
        _platformID = selectedPlatform ?? 1;
        notifyListeners();
      }
    }
  }

  final Map<String, List<FileData>> _regularIconFiles = {}, _adaptiveIconFiles = {}, _xmlConfigs = {}, _pwaConfigs = {};

  Future archive() async {
    _exportedDoneCount = 0;
    _setLoading(true);

    final IconGenerator genertator = IconGenerator();
    final List<FileData> filesList = [];

    Future<void>.delayed(
        //TODO! Check when https://github.com/flutter/flutter/issues/33577 is closed.
        const Duration(milliseconds: kIsWeb ? 300 : 0),
        () async => await _resizeIcons().whenComplete(() async {
              for (final String key in _regularIconFiles.keys) {
                final List<FileData> folderWithIcons = _regularIconFiles[key];
                filesList.addAll(folderWithIcons.toList());
              }

              if (_exportingAdaptiveFiles) {
                for (final String key in _adaptiveIconFiles.keys) {
                  final List<FileData> _adaptiveFolder = _adaptiveIconFiles[key];
                  filesList.addAll(_adaptiveFolder.toList());
                }
                _generateXmlConfigs();
                for (final String key in _xmlConfigs.keys) {
                  final List<FileData> txtFolder = _xmlConfigs[key];
                  filesList.addAll(txtFolder.toList());
                }
              }

              if (exportWeb) {
                _generatePwaConfigs();
                for (final String key in _pwaConfigs.keys) {
                  final List<FileData> txtFolder = _pwaConfigs[key];
                  filesList.addAll(txtFolder.toList());
                }
              }

              final List<int> archiveFileData = genertator.generateArchive(filesList);
              await _saveFile('icons.zip', binaryData: archiveFileData).then((bool correctlyExported) {
                if (correctlyExported) {
                  _countdown = 0;
                  _loading = false;
                  _showSnackInfo();
                }
              });
            }));
  }

  int _countdown = 0;
  int get countdown => _countdown;

  void _showSnackInfo() {
    _exportedDoneCount = 0;
    Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      if (_countdown > 99) {
        _countdown = 0;
        timer.cancel();
      } else {
        _countdown = _countdown + 1;
      }
      notifyListeners();
    });
  }

  // Future<String> get _tempDirectory async {
  //   if (platform.isMobile) {
  //     final io.Directory dir = await getTemporaryDirectory();
  //     return dir.path;
  //   } else {
  //     return '';
  //   }
  // }

  Future<String> get _getSaveDirectory async {
    io.Directory platformSpecificDir;
    if (platform.isAndroid) {
      platformSpecificDir = await getExternalStorageDirectory();
    } else if (platform.isIOS) {
      platformSpecificDir = await getApplicationDocumentsDirectory();
    } else {
      platformSpecificDir = await getDownloadsDirectory();
    }
    return platformSpecificDir.path;
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
        await _getSaveDirectory.then((String pathToFile) async {
          io.File('$pathToFile/$fileName')
            ..createSync()
            ..writeAsBytesSync(binaryData);
          if (platform.isMobile) {
            await Share.shareFiles(['$pathToFile/$fileName'], mimeTypes: ['application/zip']);
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
    final XmlGenerator genertator =
        XmlGenerator(bgAsColor: preferColorBg, color: adaptiveColor ?? backgroundColor ?? const Color(0xFF000000));
    final List<FileData> xmlsList = genertator.generateXmls();
    _xmlConfigs[key] = xmlsList;
    _exportedDoneCount = _exportedDoneCount + 1;
    notifyListeners();
  }

  void _generatePwaConfigs({String key = 'pwa'}) {
    final PwaConfigGenerator genertator = PwaConfigGenerator(color: backgroundColor ?? const Color(0xFF000000));
    final List<FileData> configsList = genertator.generatePwaConfigs();
    _pwaConfigs[key] = configsList;
  }

  Future _generatePngIcons(String key, ImageFolder folder) async {
    final img.Image uploadedPNG = img.decodePng(_icon);
    final IconGenerator genertator = IconGenerator();
    // final String pathToTempDir = await _tempDirectory;
    final List<FileData> regularIconsList =
        await genertator.generateIcons(uploadedPNG, folder, writeToDiskIO: !kIsWeb && platform.isDesktop);
    _regularIconFiles[key] = regularIconsList;
    _exportedDoneCount = _exportedDoneCount + 1;
    notifyListeners();
  }

  Future _generateAdaptiveIcons(ImageFolder folder) async {
    final bool background = folder is BackgroundIconsFolder;
    final String key = background ? 'bg' : 'fg';
    final img.Image uploadedAdaptivePNG = img.decodePng(background ? _adaptiveBackground : _adaptiveForeground);
    final IconGenerator genertator = IconGenerator();
    // final String pathToTempDir = await _tempDirectory;
    final List<FileData> adaptiveIconsList =
        await genertator.generateIcons(uploadedAdaptivePNG, folder, writeToDiskIO: !kIsWeb && platform.isDesktop);
    _adaptiveIconFiles[key] = adaptiveIconsList;
    _exportedDoneCount = _exportedDoneCount + 1;
    notifyListeners();
  }

  Future _generateIcoIcon(ImageFolder folder, {String key = 'win'}) async {
    final img.Image uploadedPNG = img.decodePng(_icon);
    final List<FileData> icoList =
        await WindowsIcon.generate(uploadedPNG, folder, writeToDiskIO: !kIsWeb && platform.isDesktop);
    _regularIconFiles[key] = icoList;
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
