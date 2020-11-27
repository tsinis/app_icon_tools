import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_info/platform_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/locales.dart';
import '../constants/themes.dart';
import '../generated/l10n.dart';
import '../locator_di.dart';
import '../services/navigation_service.dart';
import '../services/url_opener.dart';

class UserInterface extends ChangeNotifier {
  static const double previewIconSize = 300;
  static bool _isCupertinoDesign = false, _isDark = true;
  static final List<String> _langList = [], _langFilterList = [];
  static String _locale = 'en';
  static const String _storedTheme = 'isDark', _storedLocale = 'locale', _storedDesign = 'isCupertino';

  void goBack() {
    notifyListeners();
    locator<NavigationService>().goBack();
  }

  Future showGuidelines({bool fromGoogle = false, bool isAdaptive = false}) async =>
      await openGuidelinesURL(_locale, fromGoogle: fromGoogle, isAdaptive: isAdaptive);

  Future showDocs(String _url) async => await openDocsURL(currentLocale: _locale, url: _url);

  Future showRepository() async => await openRepositoryURL();

  String get locale => _locale;

  void setLocale(String newLocale) {
    final int colon = newLocale.indexOf(':');
    _locale = newLocale.substring(0, colon).toLowerCase();
    S.load(Locale(_locale)).whenComplete(notifyListeners);
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

  static void setupUI() {
    loadSettings(isInitialization: true);
    loadLocales();
  }

  static Future loadSettings({bool isInitialization = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _locale = prefs.getString(_storedLocale) ?? platform.locale;
    _isDark = prefs.getBool(_storedTheme) ?? (DateTime.now().hour > 18 || DateTime.now().hour < 6);
    if (isInitialization) {
      _isCupertinoDesign = _selectedCupertino = prefs.getBool(_storedDesign) ?? platform.isCupertino;
    }
  }

  Future saveSettings() async {
    locator<NavigationService>().goBack();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storedLocale, _locale);
    await prefs.setBool(_storedTheme, _isDark);
    await prefs.setBool(_storedDesign, selectedCupertino);
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
