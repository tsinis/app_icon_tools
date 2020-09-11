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

  PageController _pageController;
  PageController get pageController => _pageController;
  void initState() {
    _platformID = 0;
    _pageController = PageController(viewportFraction: 0.75);
  }

  int _platformID = 0;
  int get platformID => _platformID;

  void setPlatform(int _draggedPlatformID) {
    if (_draggedPlatformID != _platformID) {
      _platformID = _draggedPlatformID;
      notifyListeners();
    }
  }

  void goTo(int _selectedPlatformID) {
    if (_selectedPlatformID != _platformID) {
      _platformID = _selectedPlatformID;
      notifyListeners();
      _pageController.animateToPage(_platformID, duration: const Duration(milliseconds: 600), curve: Curves.ease);
    }
  }
}
