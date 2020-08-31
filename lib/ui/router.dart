import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/platform_detector.dart';

import 'preview_screen.dart';
import 'views/app_appearance.dart';
import 'views/inital_upload_screen.dart';

class UiRouter {
  static const String initialRoute = 'inital_upload', previewRoute = 'preview';
  static Route<void> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return _showScreen(const InitialUploadScreen());
      case previewRoute:
        return _showScreen(const PreviewScreen());
      default:
        return _showScreen(const MyApp());
    }
  }

  static Route _showScreen(Widget _page) => CurrentPlatform.isApple
      ? CupertinoPageRoute<void>(builder: (_) => _page)
      : MaterialPageRoute<void>(builder: (_) => _page);
}
