import 'dart:io' as io;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:image_resizer/image_resizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

import '../locator.dart';
import '../services/image_resizer_windows.dart';
import '../services/navigation_service.dart';

class SetupIcon extends ChangeNotifier {
  void backButton() {
    final NavigationService _navigationService = locator<NavigationService>();
    if (_devicePreview) {
      _devicePreview = false;
      notifyListeners();
    } else {
      _navigationService.goBack();
    }
  }

  Color _backgroundColor;
  Color get backgroundColor => _backgroundColor;
  void setBackgroundColor(Color _newColor) {
    if (_backgroundColor != _newColor) {
      _backgroundColor = _newColor;
      notifyListeners();
    }
  }

  void removeColor() {
    _backgroundColor = null;
    notifyListeners();
  }

  Uint8List _icon;
  Image get iconImage => Image.memory(_icon);
  Uint8List get icon => _icon;
  set icon(Uint8List _uploadedImage) {
    if (_uploadedImage != _icon) {
      _icon = _uploadedImage;
      _iconFiles = {};
      notifyListeners();
    }
  }

  Uint8List _adaptiveBackground;
  Uint8List get adaptiveBackground => _adaptiveBackground;
  set adaptiveBackground(Uint8List _uploadedImage) {
    _adaptiveBackground = _uploadedImage;
    notifyListeners();
  }

  bool get haveAdaptiveBackground => _adaptiveBackground != null;
  void removeAdaptiveBackground() {
    _adaptiveBackground = null;
    notifyListeners();
  }

  Uint8List _adaptiveForeground;
  Uint8List get adaptiveForeground => _adaptiveForeground;
  set adaptiveForeground(Uint8List _uploadedImage) {
    _adaptiveForeground = _uploadedImage;
    notifyListeners();
  }

  bool get haveadaptiveForeground => _adaptiveForeground != null;
  void removeadaptiveForeground() {
    _adaptiveForeground = null;
    notifyListeners();
  }

  double _iconShapeRadius = 25;
  double get cornerRadius => _iconShapeRadius;
  void setRadius(double _newRadius) {
    if (_newRadius != _iconShapeRadius) {
      _iconShapeRadius = _newRadius;
      notifyListeners();
    }
  }

  bool _devicePreview = false;
  bool get devicePreview => _devicePreview;
  void changePreview() {
    _devicePreview = !_devicePreview;
    notifyListeners();
  }

  int _platformID = 0;
  int get platformID => _platformID;
  void setPlatform(int _selectedPlatform) {
    if (_devicePreview && _selectedPlatform == 1 && _adaptiveBackground == null && _adaptiveForeground == null) {
    } else if (_selectedPlatform != _platformID) {
      {
        _platformID = _selectedPlatform;
        notifyListeners();
      }
    }
  }

  Map<String, List<FileData>> _iconFiles;

  // final bool _exportIos = true, _exportWeb = true, _exportMacos = true, _exportAndroid = true;

  Future archive() async {
    _setLoading(true);
    final IconGenerator _gen = IconGenerator();
    final List<FileData> _images = [];
    Future<void>.delayed(
        const Duration(milliseconds: 300),
        () async => await _resizeIcons().whenComplete(() async {
              for (final key in _iconFiles.keys) {
                final _folder = _iconFiles[key];
                _images.addAll(_folder.toList());
              }
              // print('Images: ${_images.length}');
              final List<int> _data = _gen.generateArchive(_images);
              await _saveFile('icons.zip', binaryData: _data).whenComplete(() => _setLoading(false));
            }));
  }

  Future<bool> _saveFile(String fileName, {List<int> binaryData, bool silentErrors = false}) async {
    if (kIsWeb) {
      Uri dataUrl;
      try {
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

  Future _resizeIcons() async {
    if (_iconFiles.isEmpty) {
      await _generatePngIcons('web', WebIconsFolder());
      // await _generatePngIcons('iOS', IosIconsFolder());
      // await _generatePngIcons('macOS', MacOSIconsFolder());
      // await _generatePngIcons('android', AndroidIconsFolder());
      await _generateIcoIcon('win', WindowsIconsFolder());
    }
  }

  Future _generatePngIcons(String key, ImageFolder folder) async {
    final img.Image _image = img.decodePng(_icon);
    final IconGenerator _gen = IconGenerator();
    final List<FileData> _archive = await _gen.generateIcons(_image, folder, writeToDiskIO: !kIsWeb);
    _iconFiles[key] = _archive;
  }

  Future _generateIcoIcon(String key, ImageFolder folder) async {
    final img.Image _image = img.decodePng(_icon);
    final List<FileData> _archive = await generateWinIcos(_image, folder, writeToDiskIO: !kIsWeb);
    _iconFiles[key] = _archive;
  }

  bool _loading = false;
  bool get loading => _loading;
  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
