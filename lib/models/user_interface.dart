import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_info/platform_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../locator.dart';
import '../services/navigation_service.dart';
import 'constants/locale.dart';
import 'constants/themes.dart';

class UserInterface extends ChangeNotifier {
  static const double previewIconSize = 300;
  static int _currentTime = 12;
  static const Set<String> _googleLng = {'de', 'en', 'es', 'fr', 'id', 'jp', 'ko', 'pt', 'ru', 'th', 'tr', 'vi', 'zh'};
  static bool _isCupertinoDesign = false, _isDark = true;
  static final List<String> _langList = [], _langFilterList = [];
  static String _locale = 'en';
  static const String _storedTheme = 'isDark', _storedLocale = 'locale', _storedDesign = 'isCupertino';

  void goBack() {
    notifyListeners();
    locator<NavigationService>().goBack();
  }

  Future openGuidelinesURL({bool fromGoogle = false, bool isAdaptive = false}) async {
    final String supportedLocale = (_googleLng.contains(_locale)) ? _locale : 'en';
    const String appleURL =
        'https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/app-icon';
    final String googleURL =
            'https://support.google.com/googleplay/android-developer/answer/1078870?hl=$supportedLocale',
        adaptiveURL =
            'https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive?hl=$supportedLocale';
    final String url = isAdaptive
        ? adaptiveURL
        : fromGoogle
            ? googleURL
            : appleURL;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw ArgumentError('Could not launch $url');
    }
  }

  String get locale => _locale;

  void setLocale(String newLocale) {
    final int colon = newLocale.indexOf(':');
    _locale = newLocale.substring(0, colon).toLowerCase();
    notifyListeners();
  }

  void changeMode({@required bool isDark}) {
    _isDark = isDark;
    notifyListeners();
  }

  bool get isDark => _isDark;

  static bool _selectedCupertino;
  bool get selectedCupertino => _selectedCupertino ?? _isCupertinoDesign;

  void changeStyle({@required bool selectedCupertino}) {
    _selectedCupertino = selectedCupertino;
    notifyListeners();
  }

  static bool get isCupertino => _isCupertinoDesign;

  List<String> get langFilterList => _langFilterList;

  static void loadLocales() {
    if (_langList.isEmpty) {
      for (final Locale locale in supportedLocales) {
        _langList.add('${locale.languageCode.toUpperCase()}: ${languageNames[locale]}');
      }
      _langList.sort();
    }
    _resetFilter();
  }

  static Future setupUI() async {
    _currentTime = DateTime.now().hour;
    // ignore: unawaited_futures
    loadSettings(isInitialization: true);
    loadLocales();
  }

  static Future loadSettings({bool isInitialization = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _locale = prefs.getString(_storedLocale) ?? platform.locale;
    _isDark = prefs.getBool(_storedTheme) ?? (_currentTime > 18 || _currentTime < 6);
    if (isInitialization) {
      _isCupertinoDesign = prefs.getBool(_storedDesign) ?? platform.isCupertino;
    }
  }

  Future saveSettings() async {
    locator<NavigationService>().goBack();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storedLocale, _locale);
    await prefs.setBool(_storedTheme, _isDark);
    await prefs.setBool(_storedDesign, selectedCupertino);
    // print('Saved Settings!');
  }

  static void _resetFilter() => _langFilterList
    ..clear()
    ..addAll(_langList);

  void search(String query) {
    _resetFilter();
    if (query.isNotEmpty) {
      final List<String> filteredList = [];
      for (final String language in _langList) {
        if (language.toLowerCase().contains(query.toLowerCase())) {
          filteredList.add(language);
        }
      }
      _langFilterList
        ..clear()
        ..addAll(filteredList);
    } else {
      _resetFilter();
    }
    notifyListeners();
  }

  ThemeData get materialTheme => _isDark ? materialDark : materialLight;

  CupertinoThemeData get cupertinoTheme => _isDark ? cupertinoDark : cupertinoLight;
}
