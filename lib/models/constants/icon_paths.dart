import 'package:image_resizer/image_resizer.dart';

const String iosPath = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';

const String webPath = 'web/icons';

const String macOSPath = 'macos/Runner/Assets.xcassets/AppIcon.appiconset';

const String androidPath = 'android/app/src/main/res';

const List<IosIcon> iosIcons = [
  IosIcon(size: 20, scale: 1),
  IosIcon(size: 20, scale: 2),
  IosIcon(size: 20, scale: 3),
  IosIcon(size: 29, scale: 1),
  IosIcon(size: 29, scale: 2),
  IosIcon(size: 29, scale: 3),
  IosIcon(size: 40, scale: 1),
  IosIcon(size: 40, scale: 2),
  IosIcon(size: 40, scale: 3),
  IosIcon(size: 60, scale: 2),
  IosIcon(size: 60, scale: 3),
  IosIcon(size: 76, scale: 1),
  IosIcon(size: 76, scale: 2),
  IosIcon(size: 83, scale: 2, point5: true),
  IosIcon(size: 1024, scale: 1),
];

const List<WebIcon> webIcons = [
  WebIcon(size: 192),
  WebIcon(size: 512),
];

const List<MacOSIcon> macIcons = [
  MacOSIcon(size: 16, scale: 1, name: '16'),
  MacOSIcon(size: 16, scale: 2, name: '32'),
  MacOSIcon(size: 32, scale: 1, name: '32'),
  MacOSIcon(size: 32, scale: 2, name: '64'),
  MacOSIcon(size: 128, scale: 1, name: '128'),
  MacOSIcon(size: 128, scale: 2, name: '256'),
  MacOSIcon(size: 256, scale: 1, name: '256'),
  MacOSIcon(size: 256, scale: 2, name: '512'),
  MacOSIcon(size: 512, scale: 1, name: '512'),
  MacOSIcon(size: 512, scale: 2, name: '1024'),
];

const List<AndroidIcon> androidIcons = [
  AndroidIcon(size: 72, folderSuffix: 'hdpi'),
  AndroidIcon(size: 48, folderSuffix: 'mdpi'),
  AndroidIcon(size: 96, folderSuffix: 'xhdpi'),
  AndroidIcon(size: 144, folderSuffix: 'xxhdpi'),
  AndroidIcon(size: 192, folderSuffix: 'xxxhdpi'),
];

const WebFavicon webFavicon = WebFavicon();

const String windows = 'windows/runner/resources/appicon.ico';
