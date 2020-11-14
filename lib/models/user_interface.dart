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
  static bool _isDark = true;
  static bool _isAppleDevice = false;
  static final List<String> _langList = [], _langFilterList = [];
  static String _locale = 'en';
  static const String _storedTheme = 'isDark', _storedLocale = 'locale';

  void goBack() {
    notifyListeners();
    locator<NavigationService>().goBack();
  }

  Future openGuidelinesURL({bool fromGoogle = false, bool isAdaptive = false}) async {
    const String _apple = 'https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/app-icon';
    final String _supportedLocale = (_googleLng.contains(_locale)) ? _locale : 'en';
    final String _google =
        'https://support.google.com/googleplay/android-developer/answer/1078870?hl=$_supportedLocale';
    final String _adaptive =
        'https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive?hl=$_supportedLocale';
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

  static const List<String> _googleLng = ['de', 'en', 'es', 'fr', 'id', 'jp', 'ko', 'pt', 'ru', 'th', 'tr', 'vi', 'zh'];

  String get locale => _locale;

  void setLocale(String _newLocale) {
    final int _colon = _newLocale.indexOf(':');
    _locale = _newLocale.substring(0, _colon).toLowerCase();
    // print(_locale);
    notifyListeners();
  }

  // ignore: avoid_positional_boolean_parameters
  void changeMode(bool isDark) {
    _isDark = isDark;
    notifyListeners();
  }

  bool get isDark => _isDark;

  static bool get isApple => _isAppleDevice;

  List<String> get langFilterList => _langFilterList;

  static void loadLocales() {
    if (_langList.isEmpty) {
      for (final Locale _locale in supportedLocales) {
        _langList.add('${_locale.languageCode.toUpperCase()}: ${languageNames[_locale]}');
      }
      _langList.sort();
    }
    _resetFilter();
  }

  static Future<void> setupUI() async {
    _currentTime = DateTime.now().hour;
    // ignore: unawaited_futures
    loadSettings();
    loadLocales();
    _isAppleDevice = platform.isCupertino;
  }

  static int _currentTime = 12;

  static Future<void> loadSettings() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _locale = _prefs.getString(_storedLocale) ?? platform.locale;
    _isDark = _prefs.getBool(_storedTheme) ?? (_currentTime > 18 || _currentTime < 6);
  }

  Future<void> saveSettings() async {
    locator<NavigationService>().goBack();
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_storedLocale, _locale);
    await _prefs.setBool(_storedTheme, _isDark);
    // print('Saved Settings!');
  }

  static void _resetFilter() => _langFilterList
    ..clear()
    ..addAll(_langList);

  void search(String _query) {
    //TODO Check Issues with list not being updated.
    _resetFilter();
    if (_query.isNotEmpty) {
      final List<String> _filteredList = [];
      for (final String _lang in _langList) {
        if (_lang.toLowerCase().contains(_query.toLowerCase())) {
          _filteredList.add(_lang);
        }
      }
      _langFilterList
        ..clear()
        ..addAll(_filteredList);
    } else {
      _resetFilter();
    }
    notifyListeners();
  }

  ThemeData get materialTheme => _isDark ? materialDark : materialLight;
  CupertinoThemeData get cupertinoTheme => _isDark ? cupertinoDark : cupertinoLight;
}
