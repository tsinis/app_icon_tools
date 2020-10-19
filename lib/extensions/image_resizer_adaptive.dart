import 'package:image_resizer/image_resizer.dart';

const String _path = 'android/app/src/main/res';

class ForegroundIconsFolder extends AndroidIconsFolder {
  ForegroundIconsFolder({List<AdaptiveIcon> foregrounds = _defaultIcons, String adaptivePath = _path})
      : super(icons: foregrounds, path: adaptivePath);

  static const _defaultIcons = [
    AdaptiveIcon(adaptSize: 72, adaptSuffix: 'hdpi'),
    AdaptiveIcon(adaptSize: 48, adaptSuffix: 'mdpi'),
    AdaptiveIcon(adaptSize: 96, adaptSuffix: 'xhdpi'),
    AdaptiveIcon(adaptSize: 144, adaptSuffix: 'xxhdpi'),
    AdaptiveIcon(adaptSize: 192, adaptSuffix: 'xxxhdpi')
  ];
}

class BackgroundIconsFolder extends AndroidIconsFolder {
  BackgroundIconsFolder({List<AdaptiveIcon> backgrounds = _defaultIcons, String adaptivePath = _path})
      : super(icons: backgrounds, path: adaptivePath);

  static const _defaultIcons = [
    AdaptiveIcon(adaptSize: 72, adaptSuffix: 'hdpi', background: true),
    AdaptiveIcon(adaptSize: 48, adaptSuffix: 'mdpi', background: true),
    AdaptiveIcon(adaptSize: 96, adaptSuffix: 'xhdpi', background: true),
    AdaptiveIcon(adaptSize: 144, adaptSuffix: 'xxhdpi', background: true),
    AdaptiveIcon(adaptSize: 192, adaptSuffix: 'xxxhdpi', background: true)
  ];
}

class AdaptiveIcon extends AndroidIcon {
  const AdaptiveIcon({this.adaptSize, this.adaptFolder = 'drawable', this.adaptSuffix, this.background = false})
      : super(size: adaptSize, folder: adaptFolder, folderSuffix: adaptSuffix);
  final bool background;
  final int adaptSize;
  final String adaptFolder, adaptSuffix;

  @override
  AdaptiveIcon copyWith({
    String name,
    String folder,
    String folderSuffix,
    String ext,
    int size,
    bool background,
  }) =>
      AdaptiveIcon(background: background ?? false, adaptSize: size ?? this.size);

  @override
  String get filename => name + (background ? '_background.' : '_foreground.') + ext;
}
