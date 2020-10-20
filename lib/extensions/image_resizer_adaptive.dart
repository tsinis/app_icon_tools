import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_resizer/image_resizer.dart';
import 'xmls.dart';

const String _path = 'android/app/src/main/res';

class ForegroundIconsFolder extends AndroidIconsFolder {
  ForegroundIconsFolder({List<AdaptiveIcon> foregrounds = _defaultIcons, String adaptivePath = _path})
      : super(icons: foregrounds, path: adaptivePath);

  static const _defaultIcons = [
    AdaptiveIcon(adaptSize: 81, adaptSuffix: 'ldpi'),
    AdaptiveIcon(adaptSize: 162, adaptSuffix: 'hdpi'),
    AdaptiveIcon(adaptSize: 108, adaptSuffix: 'mdpi'),
    AdaptiveIcon(adaptSize: 216, adaptSuffix: 'xhdpi'),
    AdaptiveIcon(adaptSize: 324, adaptSuffix: 'xxhdpi'),
    AdaptiveIcon(adaptSize: 432, adaptSuffix: 'xxxhdpi')
  ];
}

class BackgroundIconsFolder extends AndroidIconsFolder {
  BackgroundIconsFolder({List<AdaptiveIcon> backgrounds = _defaultIcons, String adaptivePath = _path})
      : super(icons: backgrounds, path: adaptivePath);

  static const _defaultIcons = [
    AdaptiveIcon(adaptSize: 81, adaptSuffix: 'ldpi', background: true),
    AdaptiveIcon(adaptSize: 162, adaptSuffix: 'hdpi', background: true),
    AdaptiveIcon(adaptSize: 108, adaptSuffix: 'mdpi', background: true),
    AdaptiveIcon(adaptSize: 216, adaptSuffix: 'xhdpi', background: true),
    AdaptiveIcon(adaptSize: 324, adaptSuffix: 'xxhdpi', background: true),
    AdaptiveIcon(adaptSize: 432, adaptSuffix: 'xxxhdpi', background: true)
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

class XmlGenerator {
  XmlGenerator({
    @required this.bgAsColor,
    this.color, //TODO! Add @required here.
    this.ext = 'xml',
    this.colorsName = 'colors',
    this.iconsNames = 'ic_launcher',
    this.path = _path,
    this.colorsFolder = 'values',
    this.iconsFolder = 'mipmap-anydpi-v26',
  });
  final bool bgAsColor;
  final Color color;
  final String ext, colorsName, iconsNames, path, colorsFolder, iconsFolder;

  List<FileData> generateXmls() {
    final List<FileData> _xmls = [];
    if (bgAsColor) {
      final FileData _colorsXml = _generateColorsXML();
      _xmls.add(_colorsXml);
    }
    final FileData _iconsXml = _generateIconsXML();
    _xmls.add(_iconsXml);
    return _xmls;
  }

  String _convertColor(Color _color) {} //TODO! Add Color to String Converter.

  FileData _generateIconsXML() {
    final String xmlText = iconsXml(bgAsColor);
    final List<int> xmlAsBytes = utf8.encode(xmlText);
    return FileData(xmlAsBytes, xmlAsBytes.length, '', '$path/$iconsFolder/$iconsNames.$ext');
  }

  FileData _generateColorsXML({String color = '#FF000000'}) {
    final List<int> xmlAsBytes = utf8.encode(colorsXml(color));
    return FileData(xmlAsBytes, xmlAsBytes.length, '', '$path/$colorsFolder/$colorsName.$ext');
  }
}
