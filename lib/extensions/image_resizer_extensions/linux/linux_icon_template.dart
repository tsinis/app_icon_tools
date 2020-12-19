import 'package:flutter/foundation.dart';
import 'package:image_resizer/image_resizer.dart';

class LinuxIcon extends IconTemplate {
  const LinuxIcon({@required int size, this.prefix = '', this.ext = 'png'}) : super(size);
  final String prefix;
  final String ext;

  LinuxIcon copyWith({int size, String prefix, String ext}) =>
      LinuxIcon(prefix: prefix ?? this.prefix, size: size ?? this.size, ext: ext ?? this.ext);

  Map<String, dynamic> toJson([String folder = 'icons']) =>
      <String, dynamic>{'src': '$folder/$filename', 'sizes': '${'$size'}x${'$size'}', 'type': 'image/$ext'};

  @override
  String get filename => '$prefix${'$size'}x${'$size'}.$ext';
}
