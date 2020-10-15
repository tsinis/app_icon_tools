import 'dart:convert' as convert;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:archive/archive.dart' as web;
// import 'package:archive/archive_io.dart' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../locator.dart';
import '../services/navigation_service.dart';
import 'constants.dart';

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

  // void addWebArchiveDirectory(web.Archive arc, String name) => arc.addFile(web.ArchiveFile(name, 0, <int>[])
  //   ..isFile = false
  //   ..compress = false
  //   ..mode = 0x41FD
  //   ..crc32 = 0);

  void archive() {
    if (kIsWeb) {
      final web.Archive _archive = web.Archive();
      // addWebArchiveDirectory(_archive, '/folder/');
      final web.ArchiveFile _arcfile = web.ArchiveFile(macOS[1024], _icon.length, _icon);
      _archive.addFile(_arcfile);
      final List<int> _zipData = web.ZipEncoder().encode(_archive);
      final String base64text = convert.base64.encode(_zipData);
      querySelector('#zip') as AnchorElement
        ..href = 'data:application/zip;base64,$base64text'
        ..click();
    } else {
      //TODO! Implement mobile and desktop part of archive creation.
      // final io.Archive _archive = io.Archive();
      // final ZipFileEncoder _encoder = ZipFileEncoder()
      //   ..zipDirectory(Directory('out'), filename: 'out.zip')
      //   ..create('out2.zip')
      //   ..addDirectory(Directory('out'))
      //   ..addFile(File.fromRawPath(_icon))
      //   ..close();
    }
  }
}
