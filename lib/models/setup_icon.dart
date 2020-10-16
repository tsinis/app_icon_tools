import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:image_resizer/image_resizer.dart';
import 'package:image/image.dart' as img;
import 'package:universal_html/html.dart' as html;

import '../locator.dart';
import '../services/navigation_service.dart';
import 'constants/icon_paths.dart';
import 'constants/locale.dart';

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

  Map<String, List<FileData>> _files;

  // final bool _exportIos = true, _exportWeb = true, _exportMacos = true, _exportAndroid = true;

  Future archive() async {
    _setLoading(true);
    final IconGenerator _gen = IconGenerator();
    final List<FileData> _images = [];
    await _resizeIcons().whenComplete(() async {
      for (final key in _files.keys) {
        final _folder = _files[key];
        _images.addAll(_folder.toList());
      }
      // print('Images: ${_images.length}');
      final List<int> _data = _gen.generateArchive(_images);
      await _saveFile('icons.zip', binaryData: _data).whenComplete(() => _setLoading(false));
    });
  }

  Future<bool> _saveFile(
    String fileName, {
    // String initialDirectoryDesktop,
    List<int> binaryData,
    bool silentErrors = false,
  }) async {
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
        // ignore: unsafe_html
        ..href = dataUrl.toString()
        ..setAttribute('download', fileName)
        ..click();
      return true;
    }
    File(fileName)
      ..createSync()
      ..writeAsBytesSync(binaryData);
    return true;
  }

  Future _resizeIcons() async {
    _files = {};
    // await _generateIcons('iOS', IosIconsFolder(icons: iosIcons, path: iosPath));
    await _generateIcons('web', WebIconsFolder(icons: webIcons, favicion: webFavicon, path: webPath));
    // await _generateIcons('macOS', MacOSIconsFolder(icons: macIcons, path: macOSPath));
    // await _generateIcons('android', AndroidIconsFolder(icons: androidIcons, path: androidPath));
  }

  Future _generateIcons(String key, ImageFolder folder) async {
    final img.Image _image = img.decodePng(_icon);
    final IconGenerator _gen = IconGenerator();
    final List<FileData> _archive = await _gen.generateIcons(_image, folder, writeToDiskIO: !kIsWeb);
    _files[key] = _archive;
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
}
