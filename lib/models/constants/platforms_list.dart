import '../../ui/platform_icons/icons_screen.dart';

const List<IconPreview> _platformList = [
  IconPreview.oldAndroid(),
  IconPreview.newAndroid(),
  IconPreview.iOS(),
  IconPreview.web(),
  IconPreview.windows(),
  IconPreview.macOS(),
  //TODO: Check when https://github.com/flutter/flutter/issues/53229 is closed.
  // IconPreview.linux(),
  // IconPreview.fuchsiaOS()
];
List<IconPreview> get platformList => List.from(_platformList)..sort((a, b) => a.platformID.compareTo(b.platformID));
