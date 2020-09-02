import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_info/platform_info.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInterface extends ChangeNotifier {
  static bool _thisIsAppleDevice = false;

  Brightness _brightness = Brightness.dark;
  String _locale = 'en';

  Future openGuidelinesURL({bool fromGoogle = false}) async {
    const String _apple = 'https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/app-icon';
    final String _google = 'https://support.google.com/googleplay/android-developer/answer/1078870?hl=$_locale';
    final String _url = fromGoogle ? _google : _apple;
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw ArgumentError('Could not launch $_url');
    }
  }

  void detectUISettings() {
    _thisIsAppleDevice = platform.isCupertino;
    _locale = platform.locale;
  }

  String get locale => _locale ?? 'en';

  // ignore: avoid_setters_without_getters
  set setTheme(bool _isDark) => _brightness = _isDark ? Brightness.dark : Brightness.light;

  Brightness get getTheme => _brightness;

  static bool get isApple => _thisIsAppleDevice ?? false;
}
