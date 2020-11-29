import 'package:flutter/widgets.dart' show Size;
import 'package:platform_info/platform_info.dart';
import 'package:window_size/window_size.dart';

class DesktopWindow {
  static void setupSize() {
    if (!platform.isWeb && platform.isDesktop) {
      setWindowMinSize(const Size(320, 800));
      setWindowTitle('Icon Tools');
    }
  }
}
