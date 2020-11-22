import 'package:url_launcher/url_launcher.dart';

const Set<String> _googleLng = {'de', 'en', 'es', 'fr', 'id', 'jp', 'ko', 'pt', 'ru', 'th', 'tr', 'vi', 'zh'};

Future<void> openGuidelinesURL(String currentLocale, {bool fromGoogle = false, bool isAdaptive = false}) async {
  final String supportedLocale = (_googleLng.contains(currentLocale)) ? currentLocale : 'en';
  const String appleURL = 'https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/app-icon';
  final String googleURL = 'https://support.google.com/googleplay/android-developer/answer/1078870?hl=$supportedLocale',
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
