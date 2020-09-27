import 'package:flutter/widgets.dart';

import '../locator.dart';
import '../services/navigation_service.dart';

class SetupIcon extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();
  void backButton() {
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

  Image _icon;
  Image get icon => _icon;
  set icon(Image _uploadedImage) {
    if (_uploadedImage != _icon) {
      _adaptiveBackground = null;
      _icon = _uploadedImage;
      notifyListeners();
    }
  }

  Image _adaptiveBackground;
  Image get adaptiveBackground => _adaptiveBackground;
  set adaptiveBackground(Image _uploadedImage) {
    _adaptiveBackground = _uploadedImage;
    notifyListeners();
  }

  bool get haveAdaptiveBackground => _adaptiveBackground != null;
  void removeAdaptiveBackground() {
    _adaptiveBackground = null;
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
    if (_selectedPlatform != _platformID) {
      _platformID = _selectedPlatform;
      notifyListeners();
    }
  }
}
