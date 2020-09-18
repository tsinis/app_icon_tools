import 'package:flutter/material.dart';
import 'package:local_hero/local_hero.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import 'transparency_grid.dart';

class IconWithShape extends StatelessWidget {
  const IconWithShape({@required bool supportTransparency, bool onDevice = false, bool adaptiveIcon = false, Key key})
      : _supportTransparency = supportTransparency,
        _onDevice = onDevice,
        _adaptiveIcon = adaptiveIcon,
        super(key: key);

  final bool _supportTransparency, _onDevice, _adaptiveIcon;

  @override
  Widget build(BuildContext context) {
    final Color _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final Image _backgroundImage = context.select((SetupIcon icon) => icon.adaptiveBackground);
    final bool _colorNotSet = _backgroundColor == null;
    final bool _haveAdaptiveBackground = _backgroundImage != null;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (!_onDevice) const TransparencyGrid(),
        if (_haveAdaptiveBackground && _adaptiveIcon) _backgroundImage,
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: _colorNotSet
                  ? _supportTransparency
                      ? Colors.transparent
                      : Colors.black
                  : _adaptiveIcon && _haveAdaptiveBackground
                      ? Colors.transparent
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
