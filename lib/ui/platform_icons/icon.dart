import 'package:flutter/material.dart';
import 'package:local_hero/local_hero.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import 'transparency_grid.dart';

class IconWithShape extends StatelessWidget {
  const IconWithShape(
      {@required bool supportTransparency, bool onDevice = false, bool adaptiveBackground = false, Key key})
      : _supportTransparency = supportTransparency,
        _onDevice = onDevice,
        _adaptiveBackground = adaptiveBackground,
        super(key: key);

  final bool _supportTransparency, _onDevice, _adaptiveBackground;

  @override
  Widget build(BuildContext context) {
    final Color _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final Image _backgroundImage = context.select((SetupIcon adaptive) => adaptive.background);
    final bool _colorNotSet = _backgroundColor == null;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (!_onDevice) const TransparencyGrid(),
        if (_backgroundImage != null && _adaptiveBackground) _backgroundImage,
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: _colorNotSet
                  ? _supportTransparency
                      ? Colors.transparent
                      : Colors.black
                  : _backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(_onDevice ? 7 : 0))),
          child: LocalHero(
            tag: 'local',
            child: context.watch<SetupIcon>().icon,
          ),
        )
      ],
    );
  }
}
