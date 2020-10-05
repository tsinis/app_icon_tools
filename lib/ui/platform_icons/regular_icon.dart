import 'package:flutter/material.dart';

import 'package:local_hero/local_hero.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import 'transparency_grid.dart';

class RegularIcon extends StatelessWidget {
  const RegularIcon({@required bool supportTransparency, bool adaptiveIcon = false, int cornerRadius, Key key})
      : _supportTransparency = supportTransparency,
        _adaptiveIcon = adaptiveIcon,
        _cornerRadius = cornerRadius,
        super(key: key);

  final bool _supportTransparency, _adaptiveIcon;
  final int _cornerRadius;
  bool get _onDevice => _cornerRadius != null;

  @override
  Widget build(BuildContext context) {
    final Color _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final Image _backgroundImage = context.select((SetupIcon icon) => icon.adaptiveBackground);
    final bool _colorNotSet = _backgroundColor == null;
    final bool _haveAdaptiveBackground = _backgroundImage != null;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(_onDevice ? _cornerRadius / 8 ?? 0 : 0)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!_onDevice) const TransparencyGrid(),
          if (_haveAdaptiveBackground && _adaptiveIcon)
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                child: Transform.scale(scale: 1.42, child: _backgroundImage)),
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: _colorNotSet
                    ? _supportTransparency
                        ? Colors.transparent
                        : Colors.black
                    : _adaptiveIcon
                        ? Colors.transparent
                        : _backgroundColor),
            child: LocalHero(tag: 'local', child: context.watch<SetupIcon>().icon),
          ),
        ],
      ),
    );
  }
}
