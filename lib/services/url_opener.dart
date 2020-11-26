import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/platforms/platforms_docs_urls.dart';

// const Set<String> _googleLng = {'de', 'en', 'es', 'fr', 'id', 'jp', 'ko', 'pt', 'ru', 'th', 'tr', 'vi', 'zh'};
// String _supportedLocale(String currentLocale) => (_googleLng.contains(currentLocale)) ? currentLocale : 'en';

Future<void> openGuidelinesURL(String currentLocale, {bool fromGoogle = false, bool isAdaptive = false}) async {
  // final String supportedLocale = _supportedLocale(currentLocale);
  // final String googleURL = 'https://support.google.com/googleplay/android-developer/answer/1078870?hl=$supportedLocale',
  // adaptiveURL = 'https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive?hl=$supportedLocale';
  final String url = isAdaptive
      ? PlatformDocs.androidNew
      : fromGoogle
          ? PlatformDocs.androidOld
          : PlatformDocs.iOS;

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw ArgumentError('Could not launch $url');
  }
}

Future<void> openDocsURL({@required String currentLocale, @required String url}) async {
  // final String supportedLocale = _supportedLocale(currentLocale);
  // final bool isTranslated = url.substring(url.length - 1) == '=';
  // final String translatedURL = isTranslated ? url + supportedLocale : url;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw ArgumentError('Could not launch $url');
  }
}

Future<void> openRepositoryURL() async {
  const String repositoryUrl = 'https://github.com/tsinis/';
  if (await canLaunch(repositoryUrl)) {
    await launch(repositoryUrl);
  } else {
    // ignore: only_throw_errors
    throw 'Could not launch $repositoryUrl';
  }
}
