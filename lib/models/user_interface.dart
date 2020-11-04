import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_info/platform_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../locator.dart';
import '../services/navigation_service.dart';
import 'constants/locale.dart';

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
    // ignore: unawaited_futures
    loadSettings();
    loadLocales();
    _isAppleDevice = platform.isCupertino;
  }

  static Future<void> loadSettings() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _locale = _prefs.getString(_storedLocale) ?? platform.locale;
    _isDark = _prefs.getBool(_storedTheme) ?? true;
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

  ThemeData get materialTheme => _isDark ? _materialDark : _materialLight;

  static final ThemeData _materialDark = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
      appBarTheme: AppBarTheme(color: Colors.grey[800]),
      primaryColor: Colors.grey[900],
      primaryColorLight: Colors.greenAccent[100],
      sliderTheme: SliderThemeData(thumbColor: Colors.grey[100]),
      accentColor: Colors.pink[300],
      errorColor: const Color(0xFFBB5B68),
      buttonColor: Colors.grey[800],
      selectedRowColor: Colors.pink[300],
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(primary: Colors.white, minimumSize: const Size(64, 35)),
      ));

  static final ThemeData _materialLight = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    appBarTheme: AppBarTheme(color: Colors.white, iconTheme: IconThemeData(color: Colors.grey[700])),
    primaryColor: Colors.grey[200],
    primaryColorLight: Colors.greenAccent,
    sliderTheme: SliderThemeData(thumbColor: Colors.grey[600]),
    accentColor: Colors.greenAccent,
    errorColor: const Color(0xFFBB5B93),
    buttonColor: Colors.grey[350],
    selectedRowColor: const Color(0xFF51BB96),
    textButtonTheme:
        TextButtonThemeData(style: TextButton.styleFrom(primary: Colors.grey[800], minimumSize: const Size(64, 35))),
  );

  CupertinoThemeData get cupertinoTheme => _isDark ? _cupertinoDark : _cupertinoLight;

  static const CupertinoThemeData _cupertinoDark = CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: CupertinoColors.systemGrey,
      primaryContrastingColor: CupertinoColors.systemGrey2,
      barBackgroundColor: CupertinoColors.systemGrey5,
      scaffoldBackgroundColor: CupertinoColors.systemGrey6);

  static const CupertinoThemeData _cupertinoLight = CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.systemGrey,
      primaryContrastingColor: CupertinoColors.systemGrey6,
      barBackgroundColor: CupertinoColors.systemGrey6,
      scaffoldBackgroundColor: CupertinoColors.systemGrey5);
}
