import 'platforms_icons_settings.dart';

const List<PlatformIcon> _platformList = [
  PlatformIcon.androidOld(),
  PlatformIcon.androidNew(),
  PlatformIcon.iOS(),
  PlatformIcon.pwa(),
  PlatformIcon.windows(),
  PlatformIcon.macOS(),
  //TODO! Check when https://github.com/flutter/flutter/issues/53229 is closed.
  // PlatformIcon.linux(),
  // PlatformIcon.fuchsiaOS()

  // You can add your own platforms like that:
  // PlatformIcon(8, 'New Platform Name', Icons.check, cornerRadius: 20, docs: 'https://website.com'),
];
List<PlatformIcon> get platformList => List.from(_platformList)..sort((a, b) => a.platformID.compareTo(b.platformID));
