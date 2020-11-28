import 'package:flutter/foundation.dart';
import 'package:image_resizer/image_resizer.dart';

const List<_SafeIosIcon> _iOsIcons = [
  _SafeIosIcon(safeSize: 20),
  _SafeIosIcon(safeSize: 20, safeScale: 2),
  _SafeIosIcon(safeSize: 20, safeScale: 3),
  _SafeIosIcon(safeSize: 29),
  _SafeIosIcon(safeSize: 29, safeScale: 2),
  _SafeIosIcon(safeSize: 29, safeScale: 3),
  _SafeIosIcon(safeSize: 40),
  _SafeIosIcon(safeSize: 40, safeScale: 2),
  _SafeIosIcon(safeSize: 40, safeScale: 3),
  _SafeIosIcon(safeSize: 60, safeScale: 2),
  _SafeIosIcon(safeSize: 60, safeScale: 3),
  _SafeIosIcon(safeSize: 76),
  _SafeIosIcon(safeSize: 76, safeScale: 2),
  _SafeIosIcon(safeSize: 83, safeScale: 2, safePoint5: true),
  _SafeIosIcon(safeSize: 1024),
];

List<_SafeIosIcon> get iOsIcons => _iOsIcons;

class _SafeIosIcon extends IosIcon {
  const _SafeIosIcon({
    @required int safeSize,
    this.safeScale = 1,
    this.safePoint5 = false,
  }) : super(size: safeSize, scale: safeScale, point5: safePoint5);
  final int safeScale;
  final bool safePoint5;

  //Fix for Windows version of the app, it's contain sizes with a ".0" in name of icon (as a double)...
  @override
  String get filename =>
      '$prefix${safePoint5 ? adjustedSize : adjustedSize.round()}x${safePoint5 ? adjustedSize : adjustedSize.round()}@${safeScale}x.$ext';
}
