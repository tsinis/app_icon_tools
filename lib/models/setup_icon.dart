import 'package:flutter/widgets.dart';

class SetupIcon extends ChangeNotifier {
  Image _icon;
  Image get icon => _icon;
  set icon(Image _uploadedImage) {
    if (_uploadedImage != _icon) {
      _icon = _uploadedImage;
      // notifyListeners();
    }
  }

  double _iconShapeRadius = 18.326;
  void setRadius(double _newRadius) {
    if (_newRadius != _iconShapeRadius) {
      _iconShapeRadius = _newRadius;
      notifyListeners();
    }
  }

  double get cornerRadius => _iconShapeRadius;
}
