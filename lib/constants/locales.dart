import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../generated/l10n.dart';

const Iterable<LocalizationsDelegate<dynamic>> localizationDelgates = [
  S.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

List<Locale> supportedLocales = S.delegate.supportedLocales;

// Use the two-letter code if there is one.
// http://cldr.unicode.org/index/cldr-spec/picking-the-right-language-code#TOC-Choosing-the-Base-Language-Code
Map<Locale, String> languageNames = {
  const Locale('en'): 'English',
  const Locale('ru'): 'Русский',
  const Locale('cs'): 'Čeština',
  const Locale('sk'): 'Slovenčina',
};
