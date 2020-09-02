import 'package:flutter/widgets.dart';

class SetupIcon extends ChangeNotifier {
  Image _icon;
  Image get icon => _icon;
  set icon(Image uploadedImage) {
    if (uploadedImage != icon) {
      _icon = uploadedImage;
      // notifyListeners();
    }
  }
}
