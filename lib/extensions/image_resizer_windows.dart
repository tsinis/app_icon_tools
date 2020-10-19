import 'package:image/image.dart';
import 'package:image_resizer/image_resizer.dart';

class WindowsIconsFolder extends ImageFolder {
  WindowsIconsFolder({String path = 'windows/runner/resources', List<WindowsIcon> icons = _defaultIcons})
      : super(path, icons);
  static const _defaultIcons = [
    WindowsIcon(size: 256),
    WindowsIcon(size: 64), // Optional.
    WindowsIcon(size: 48),
    WindowsIcon(size: 32),
    WindowsIcon(size: 24), // Optional.
    WindowsIcon(size: 16),
  ];
}

class WindowsIcon extends IconTemplate {
  const WindowsIcon({int size = 256, this.name = 'appicon', this.ext = 'ico'}) : super(size);
  final String name;
  final String ext;

  WindowsIcon copyWith({int size, String name, String ext}) =>
      WindowsIcon(size: size ?? this.size, ext: ext ?? this.ext, name: name ?? this.name);

  @override
  String get filename => '$name.$ext';
}

Future<List<FileData>> generateWinIcos(Image image, ImageFolder folder,
    {String path = '', bool writeToDiskIO = true}) async {
  final List<Image> _images = [];
  final String _filename = folder.templates.first.filename;
  for (final template in folder.templates) {
    final Image _icon = _createResizedImage(template, image);
    _images.add(_icon);
  }
  final String _fullPath = path.isNotEmpty ? '$path/$_filename' : '${folder.path}/$_filename';
  final List<int> _icoBytes = encodeIcoImages(_images);
  return [FileData(_icoBytes, _icoBytes.length, '', _fullPath)];
}

Image _createResizedImage(IconTemplate template, Image image) =>
    copyResize(image, width: template.size, interpolation: Interpolation.linear);
