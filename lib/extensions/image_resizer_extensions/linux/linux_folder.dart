import 'package:image_resizer/image_resizer.dart';

import 'linux_icon_template.dart';

class LinuxIconsFolder extends ImageFolder {
  LinuxIconsFolder({String path = 'linux/flutter/icons', List<LinuxIcon> icons = _defaultIcons}) : super(path, icons);

  static const _defaultIcons = [
    LinuxIcon(size: 16),
    // LinuxIcon(size: 22),
    LinuxIcon(size: 32),
    LinuxIcon(size: 48),
    LinuxIcon(size: 64),
    LinuxIcon(size: 128),
    LinuxIcon(size: 256),
    // LinuxIcon(size: 512),
  ];
}
