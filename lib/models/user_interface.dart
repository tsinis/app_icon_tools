import 'package:flutter/cupertino.dart';
import 'package:platform_info/platform_info.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInterface extends ChangeNotifier {
  static bool _thisIsAppleDevice = false;

  Brightness _brightness = Brightness.dark;
  bool _isWeb = false;
  String _locale = 'en';

  Future openGuidelinesURL({bool fromGoogle = false, bool isAdaptive = false}) async {
    const String _apple = 'https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/app-icon';
    //TODO! Filter locales.
    final String _google = 'https://support.google.com/googleplay/android-developer/answer/1078870?hl=$_locale';
    final String _adaptive =
        'https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive?hl=$_locale';
    final String _url = isAdaptive
        ? _adaptive
        : fromGoogle
            ? _google
            : _apple;
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw ArgumentError('Could not launch $_url');
    }
  }

  void detectUISettings() {
    _thisIsAppleDevice = platform.isCupertino;
    _isWeb = platform.isWeb;
    _locale = platform.locale;
  }

  String get locale => _locale ?? 'en';

  bool get isWeb => _isWeb ?? false;

  // ignore: avoid_positional_boolean_parameters
  void changeMode(bool _isDark) {
    _brightness = _isDark ? Brightness.dark : Brightness.light;
    notifyListeners();
  }

  bool get isDark => _brightness == Brightness.dark;
  Brightness get getTheme => _brightness;

  static bool get isApple => _thisIsAppleDevice ?? false;
}
