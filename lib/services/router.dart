import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user_interface.dart';
import '../ui/views/device_preview_screen.dart';
import '../ui/views/setup_icon_screen.dart';
import '../ui/views/upload_file_screen.dart';

class UiRouter {
  static const String initialScreen = 'upload', setupScreen = 'setup', deviceScreen = 'device';

  static Route<void> generateRoute(RouteSettings screen) {
    switch (screen.name) {
      case deviceScreen:
        return _showScreen(const DeviceScreen());
      case setupScreen:
        return _showScreen(const SetupScreen());
      default:
        return _showScreen(const InitialUploadScreen());
    }
  }

  static Route _showScreen(Widget screen) =>
      UserInterface.isCupertino ? _CupertinoPageRoute((_) => screen) : _MaterialPageRoute((_) => screen);
}

class _MaterialPageRoute extends MaterialPageRoute<void> {
  _MaterialPageRoute(Widget Function(BuildContext) _builder) : super(builder: _builder);
  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);
}

class _CupertinoPageRoute extends MaterialPageRoute<void> {
  _CupertinoPageRoute(Widget Function(BuildContext) _builder) : super(builder: _builder);
  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);
}
