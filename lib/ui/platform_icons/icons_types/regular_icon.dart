import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/setup_icon.dart';
import '../../widgets/transparency_grid.dart';

class RegularIcon extends StatelessWidget {
  const RegularIcon({@required bool supportTransparency, @required int cornerRadius, Key key})
      : _supportTransparency = supportTransparency,
        _cornerRadius = cornerRadius,
        super(key: key);

  final bool _supportTransparency;
  final int _cornerRadius;
  bool get _onDevice => _cornerRadius != -1;

  @override
  Widget build(BuildContext context) {
    final int _selectedPlatform = context.select((SetupIcon icon) => icon.platformID);
    final Color _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final bool _colorNotSet = _backgroundColor == null;
    final bool _webSafeZone = _selectedPlatform == 3;
    final Image _icon = context.select((SetupIcon icon) => icon.iconImage);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(_onDevice ? _cornerRadius / 8 : 0)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!_onDevice) const TransparencyGrid(),
          Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: _colorNotSet
                      ? _supportTransparency
                          ? Colors.transparent
                          : Colors.black
                      : _backgroundColor),
              child:
                  Transform.scale(scale: _webSafeZone ? 1.24 : 1, child: _icon)), //TODO Add scale to web maskable icon.
        ],
      ),
    );
  }
}
