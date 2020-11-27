import 'package:flutter/foundation.dart';

import '../../constants/platforms/platforms_names.dart';

// ignore: avoid_classes_with_only_static_members
class ExportPlatform {
  static final Map<String, bool> _platforms = {
    PlatformName.androidOld: true,
    PlatformName.androidNew: true,
    PlatformName.iOS: true,
    PlatformName.pwa: true,
    PlatformName.windows: true,
    PlatformName.macOS: true,
    // PlatformName.linux: true,
    // PlatformName.fuchsia: true,
  };

  static void setPlatformToExport(String platformName, {@required bool isExported}) =>
      _platforms[platformName] = isExported;

  static int get count => _platforms.values.where((willBeExported) => true).length;

  static Map<String, bool> get mapEvery => _platforms;

  static bool get androidOld => _platforms[PlatformName.androidOld] ?? true;
  static bool get androidNew => _platforms[PlatformName.androidNew] ?? true;
  static bool get iOS => _platforms[PlatformName.iOS] ?? true;
  static bool get pwa => _platforms[PlatformName.pwa] ?? true;
  static bool get windows => _platforms[PlatformName.windows] ?? true;
  static bool get macOS => _platforms[PlatformName.macOS] ?? true;
  static bool get linux => _platforms[PlatformName.linux] ?? true;
  static bool get fuchsia => _platforms[PlatformName.fuchsia] ?? true;
}
