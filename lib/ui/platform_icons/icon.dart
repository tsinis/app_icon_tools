import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import 'transparency_grid.dart';

class IconWithShape extends StatelessWidget {
  const IconWithShape({@required bool supportTransparency, bool onDevice = false, Key key})
      : _supportTransparency = supportTransparency,
        _onDevice = onDevice,
        super(key: key);

  final bool _supportTransparency, _onDevice;

  @override
  Widget build(BuildContext context) {
    final Color _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final bool _colorNotSet = _backgroundColor == null;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (!_onDevice) const TransparencyGrid(),
        Container(
            color: _colorNotSet
                ? _supportTransparency
                    ? Colors.transparent
                    : Colors.black
                : _backgroundColor,
            child: context.watch<SetupIcon>().icon)
      ],
    );
  }
}
