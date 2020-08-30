import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/platform_detector.dart';

import 'views/app_appearance.dart';

class UiRouter {
  static const String initialRoute = 'root', previewRoute = 'preview';
  static Route<void> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return _showScreen(const MyApp());
      case previewRoute:
        return _showScreen(const MyApp());
      default:
        return _showScreen(const MyApp());
    }
  }

  static Route _showScreen(Widget _page) => CurrentPlatform.isApple
      ? CupertinoPageRoute<void>(builder: (_) => _page)
      : MaterialPageRoute<void>(builder: (_) => _page);
}
