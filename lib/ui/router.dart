import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_interface.dart';

import 'views/inital_upload_screen.dart';
import 'views/setup_screen.dart';

class UiRouter {
  static const String initialScreen = 'inital_upload', setupScreen = 'setup';
  static Route<void> generateRoute(RouteSettings screen) {
    switch (screen.name) {
      // case initialScreen:
      //   return _showScreen(const InitialUploadScreen());
      case setupScreen:
        return _showScreen(const SetupScreen());
      default:
        return _showScreen(const InitialUploadScreen());
    }
  }

  static Route _showScreen(Widget _screen) => UserInterface.isApple
      ? CupertinoPageRoute<void>(builder: (_) => _screen)
      : MaterialPageRoute<void>(builder: (_) => _screen);
}
