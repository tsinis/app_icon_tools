import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:image_resizer/image_resizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

import '../extensions/image_resizer_adaptive.dart';
import '../extensions/image_resizer_windows.dart';
import '../locator.dart';
import '../services/navigation_service.dart';
import '../services/router.dart';

class SetupIcon extends ChangeNotifier {
  void devicePreview() => locator<NavigationService>().navigateTo(UiRouter.deviceScreen);
  void setupScreen() => locator<NavigationService>().navigateAndReplaceTo(UiRouter.setupScreen);
  void goBack() => locator<NavigationService>().goBack();

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

  Uint8List _icon = Uint8List(0);
  Image get iconImage => Image.memory(_icon);
  Uint8List get regularIcon => _icon;
  set regularIcon(Uint8List _uploadedImage) {
    if (_uploadedImage != _icon) {
      _icon = _uploadedImage;
      _archiveFiles = {};
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
  Uint8List _adaptiveBackground;
  Uint8List get adaptiveBackground => _adaptiveBackground;
  set adaptiveBackground(Uint8List _uploadedImage) {
    _adaptiveBackground = _uploadedImage;
    _archiveFiles = {};
    notifyListeners();
  }

  bool get haveAdaptiveBackground => _adaptiveBackground != null;
  void removeAdaptiveBackground() {
    _adaptiveBackground = null;
    _bgErrCodes = {};
    notifyListeners();
  }

  Uint8List _adaptiveForeground;
  Uint8List get adaptiveForeground => _adaptiveForeground;
  set adaptiveForeground(Uint8List _uploadedImage) {
    _adaptiveForeground = _uploadedImage;
    _archiveFiles = {};
    notifyListeners();
  }

  bool get haveAdaptiveForeground => _adaptiveForeground != null;
  void removeadaptiveForeground() {
    _adaptiveForeground = null;
    _fgErrCodes = {};
    notifyListeners();
  }

  Map<int, bool> _fgErrCodes = {}, _bgErrCodes = {}, _iconErrCodes = {};
  List<int> get listFgErrCodes => _fgErrCodes.keys.where((key) => _fgErrCodes[key] ?? false).toList();

// ignore: avoid_setters_without_getters
  set foregroundErrorCodes(Map<int, bool> _issuesMap) {
    if (_fgErrCodes != _issuesMap) {
      _fgErrCodes = _issuesMap;
      // notifyListeners();
    }
  }

  List<int> get listBgErrCodes => _bgErrCodes.keys.where((key) => _bgErrCodes[key] ?? false).toList();

// ignore: avoid_setters_without_getters
  set backgroundErrorCodes(Map<int, bool> _issuesMap) {
    if (_bgErrCodes != _issuesMap) {
      _bgErrCodes = _issuesMap;
      // notifyListeners();
    }
  }

  List<int> get listIconErrCodes => _iconErrCodes.keys.where((key) => _iconErrCodes[key] ?? false).toList();

// ignore: avoid_setters_without_getters
  set iconErrorCodes(Map<int, bool> _issuesMap) {
    if (_iconErrCodes != _issuesMap) {
      _iconErrCodes = _issuesMap;
      // notifyListeners();
    }
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

  Map<String, List<FileData>> _archiveFiles = {};

  Future archive() async {
    _setLoading(true);
    final IconGenerator _gen = IconGenerator();
    final List<FileData> _images = [];
    Future<void>.delayed(
        //TODO! Fix workaround! Run in Isolate if !kIsWeb...
        const Duration(milliseconds: 300),
        () async => await _resizeIcons().whenComplete(() async {
              for (final key in _archiveFiles.keys) {
                final List<FileData> _folder = _archiveFiles[key];
                _images.addAll(_folder.toList());
              }
              // print('Images: ${_images.length}');
              final List<int> _data = _gen.generateArchive(_images);
              await _saveFile('icons.zip', binaryData: _data).whenComplete(() {
                _countDown = 0;
                _setLoading(false);
                _showSnackInfo();
              });
            }));
  }

  int _countDown = 0;
  int get countDown => _countDown;

  void _showSnackInfo() => Timer.periodic(
        const Duration(milliseconds: 50),
        (Timer _timer) {
          if (_countDown > 99) {
            _countDown = 0;
            _timer.cancel();
          } else {
            _countDown = _countDown + 1;
          }
          notifyListeners();
        },
      );

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
          throw Exception('Error Creating File Data: $e');
        }
        return false;
      }
      html.AnchorElement()
        ..href = dataUrl.toString()
        ..setAttribute('download', fileName)
        ..click();
      return true;
    }
    await getDownloadsDirectory().then((_downloadsDir) => io.File('${_downloadsDir.path}/$fileName')
      ..createSync()
      ..writeAsBytesSync(binaryData));
    return true;
  }

  bool get exportIOS => _platforms[_ios] ?? true;
  bool get exportWeb => _platforms[_web] ?? true;
  bool get exportAdaptive => _platforms[_androidAdapt] ?? true;

  Future _resizeIcons() async {
    if (_archiveFiles.isEmpty) {
      if (_platforms[_web] ?? true) {
        await _generatePngIcons('web', WebIconsFolder());
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
        await _generatePngIcons('droid', AndroidIconsFolder());
      }
      if (_platforms[_androidAdapt] ?? true) {
        if (haveAdaptiveForeground && (haveAdaptiveBackground || haveAdaptiveColor)) {
          if (!preferColorBg) {
            await _generateAdaptiveIcons(BackgroundIconsFolder());
          }
          _generateXmlConfigs();
          await _generateAdaptiveIcons(ForegroundIconsFolder());
        }
      }
      // if (_platforms[_linux] ?? true) {
      //   await _generatePngIcons('linux', WebIconsFolder());
      // }
      // if (_platforms[_fuchsiaOS] ?? true) {
      //   await _generatePngIcons('fos', WebIconsFolder());
      // }
    }
  }

  void _generateXmlConfigs({String key = 'xml'}) {
    final XmlGenerator _gen = XmlGenerator(bgAsColor: preferColorBg, color: adaptiveColor ?? const Color(0xFF000000));
    final List<FileData> _archive = _gen.generateXmls();
    _archiveFiles[key] = _archive;
  }

  Future _generatePngIcons(String key, ImageFolder folder) async {
    final img.Image _image = img.decodePng(_icon);
    final IconGenerator _gen = IconGenerator();
    final List<FileData> _archive = await _gen.generateIcons(_image, folder, writeToDiskIO: !kIsWeb);
    _archiveFiles[key] = _archive;
  }

  Future _generateAdaptiveIcons(ImageFolder folder) async {
    final bool _background = folder is BackgroundIconsFolder;
    final String _key = _background ? 'bg' : 'fg';
    final img.Image _image = img.decodePng(_background ? _adaptiveBackground : _adaptiveForeground);
    final IconGenerator _gen = IconGenerator();
    final List<FileData> _archive = await _gen.generateIcons(_image, folder, writeToDiskIO: !kIsWeb);
    _archiveFiles[_key] = _archive;
  }

  Future _generateIcoIcon(ImageFolder folder, {String key = 'win'}) async {
    final img.Image _image = img.decodePng(_icon);
    final List<FileData> _archive = await generateWinIcos(_image, folder, writeToDiskIO: !kIsWeb);
    _archiveFiles[key] = _archive;
  }

  bool _loading = false;
  bool get loading => _loading;
  void _setLoading(bool newValue) {
    _loading = newValue;
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
    _platforms[platformNameKey] = isExported;
    notifyListeners();
  }
}
