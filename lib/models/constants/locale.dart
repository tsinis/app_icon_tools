import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../generated/l10n.dart';

const Iterable<LocalizationsDelegate<dynamic>> localizationDelgates = [
  S.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

List<Locale> supportedLocales = S.delegate.supportedLocales;

Map<Locale, String> languageNames = {
  const Locale('en'): 'English',
  const Locale('ru'): 'Русский',
};
