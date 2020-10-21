import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/setup_icon.dart';
import '../../widgets/transparency_grid.dart';

class RegularIcon extends StatelessWidget {
  const RegularIcon({@required bool supportTransparency, int cornerRadius, Key key})
      : _supportTransparency = supportTransparency,
        _cornerRadius = cornerRadius,
        super(key: key);

  final bool _supportTransparency;
  final int _cornerRadius;
  bool get _onDevice => _cornerRadius != null;

  @override
  Widget build(BuildContext context) {
    final Color _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final bool _colorNotSet = _backgroundColor == null;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(_onDevice ? _cornerRadius / 8 ?? 0 : 0)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!_onDevice) const TransparencyGrid(),
          Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: _colorNotSet
                      ? _supportTransparency
                          ? Colors.transparent
                          : Colors.black
                      : _backgroundColor),
              child: context.watch<SetupIcon>().iconImage),
        ],
      ),
    );
  }
}
