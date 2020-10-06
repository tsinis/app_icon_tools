import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/user_interface.dart';
import '../../../platform_icons/apdative_icon.dart';

class AdaptiveIconButtons extends StatelessWidget {
  final bool withAdaptiveBackground;

  const AdaptiveIconButtons({Key key, this.withAdaptiveBackground = false}) : super(key: key);
  @override
  Widget build(BuildContext context) => UserInterface.isApple
      ? Tooltip(
          message: withAdaptiveBackground ? S.of(context).noBackground : S.of(context).parallax,
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <_CupertinoIconButton>[
              _CupertinoIconButton(
                  direction: 'left', icon: CupertinoIcons.arrow_left, withAdaptiveBackground: withAdaptiveBackground),
              _CupertinoIconButton(
                  direction: 'right', icon: CupertinoIcons.arrow_right, withAdaptiveBackground: withAdaptiveBackground),
              _CupertinoIconButton(
                  direction: 'down', icon: CupertinoIcons.arrow_down, withAdaptiveBackground: withAdaptiveBackground),
              _CupertinoIconButton(
                  direction: 'up', icon: CupertinoIcons.arrow_up, withAdaptiveBackground: withAdaptiveBackground),
            ],
          ),
        )
      : Tooltip(
          message: withAdaptiveBackground ? S.of(context).noBackground : S.of(context).parallax,
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <IconButton>[
              IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: withAdaptiveBackground ? () => _onPressed(direction: 'left') : null),
              IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: withAdaptiveBackground ? () => _onPressed(direction: 'right') : null),
              IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  onPressed: withAdaptiveBackground ? () => _onPressed(direction: 'down') : null),
              IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: withAdaptiveBackground ? () => _onPressed(direction: 'up') : null),
            ],
          ),
        );
}

void _onPressed({@required String direction}) => AdaptiveIcon.preview(direction);

class _CupertinoIconButton extends StatelessWidget {
  const _CupertinoIconButton({@required this.withAdaptiveBackground, this.direction, this.icon, Key key})
      : super(key: key);

  final bool withAdaptiveBackground;
  final String direction;
  final IconData icon;

  @override
  Widget build(BuildContext context) => CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // color: CupertinoColors.activeBlue,
      onPressed: withAdaptiveBackground ? () => _onPressed(direction: direction) : null,
      child: Center(child: Icon(icon)));
}
