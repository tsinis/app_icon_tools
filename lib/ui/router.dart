import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/platform_detector.dart';
import 'views/inital_upload_screen.dart';
import 'views/setup_screen.dart';

class UiRouter {
  static const String initialScreen = 'inital_upload', setupScreen = 'setup';
  static Route<void> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialScreen:
        return _showScreen(const InitialUploadScreen());
      case setupScreen:
        return _showScreen(const SetupScreen());
      default:
        return _showScreen(const InitialUploadScreen());
    }
  }

  static Route _showScreen(Widget _screen) => CurrentPlatform.isApple
      ? CupertinoPageRoute<void>(builder: (_) => _screen)
      : MaterialPageRoute<void>(builder: (_) => _screen);
}
