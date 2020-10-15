import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../generated/l10n.dart';

const Iterable<LocalizationsDelegate<dynamic>> localizationDelgates = [
  S.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate
];

List<Locale> supportedLocales = S.delegate.supportedLocales;

// Icons paths.

const String _androidRoot = '/android/app/src/main/res/android';
const String _androidPng = 'ic_launcher.png';
const Map<String, String> android = {
  'hdpi': '$_androidRoot/mipmap-hdpi/$_androidPng',
  'mdpi': '$_androidRoot/mipmap-mdpi/$_androidPng',
  'xhdpi': '$_androidRoot/mipmap-xhdpi/$_androidPng',
  'xxhdpi': '$_androidRoot/mipmap-xxxhdpi/$_androidPng',
  'xxxhdpi': '$_androidRoot/mipmap-xxxhdpi/$_androidPng'
};

const String _iOsRoot = '/ios/Runner/Assets.xcassets/AppIcon.appiconset';
const Map<String, String> iOS = {
  '2x20': '$_iOsRoot/Icon-App-20x20@2x.png',
  '3x20': '$_iOsRoot/Icon-App-20x20@3x.png',
  '1x29': '$_iOsRoot/Icon-App-29x29@1x.png',
  '2x29': '$_iOsRoot/Icon-App-29x29@2x.png',
  '3x29': '$_iOsRoot/Icon-App-29x29@3x.png',
  '2x40': '$_iOsRoot/Icon-App-40x40@2x.png',
  '3x40': '$_iOsRoot/Icon-App-40x40@3x.png',
  '2x60': '$_iOsRoot/Icon-App-60x60@2x.png',
  '3x60': '$_iOsRoot/Icon-App-60x60@3x.png',
  '1x20': '$_iOsRoot/Icon-App-20x20@1x.png',
  '1x40': '$_iOsRoot/Icon-App-40x40@1x.png',
  '1x76': '$_iOsRoot/Icon-App-76x76@1x.png',
  '2x76': '$_iOsRoot/Icon-App-76x76@2x.png',
  '2x83': '$_iOsRoot/Icon-App-83.5x83.5@2x.png',
  '1x1024': '$_iOsRoot/Icon-App-1024x1024@1x.png'
};

const String _macRoot = '/macos/Runner/Assets.xcassets/AppIcon.appiconset';
const Map<int, String> macOS = {
  16: '$_macRoot/app_icon_16.png',
  32: '$_macRoot/app_icon_32.png',
  64: '$_macRoot/app_icon_64.png',
  128: '$_macRoot/app_icon_128.png',
  256: '$_macRoot/app_icon_256.png',
  512: '$_macRoot/app_icon_512.png',
  1024: '$_macRoot/app_icon_1024.png'
};

const Map<int, String> web = {192: '/web/icons/Icon-192.png', 512: '/web/icons/Icon-512.png'};

const String windows = '/windows/runner/resources/appicon.ico';
