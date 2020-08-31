import 'package:platform_info/platform_info.dart';

// ignore: avoid_classes_with_only_static_members
class CurrentPlatform {
  static bool _thisIsAppleDevice = false;
  static void detect() => _thisIsAppleDevice = platform.isCupertino;
  static bool get isApple => _thisIsAppleDevice ?? false;
}
