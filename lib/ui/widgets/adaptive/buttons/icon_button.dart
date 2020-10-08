import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/user_interface.dart';
import '../../../platform_icons/apdative_icon.dart';

class AdaptiveIconButtons extends StatelessWidget {
  final bool withAdaptives;

  const AdaptiveIconButtons({Key key, this.withAdaptives = false}) : super(key: key);
  @override
  Widget build(BuildContext context) => Tooltip(
        message: withAdaptives ? S.of(context).parallax : S.of(context).noBackground,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: UserInterface.isApple
              ? <_CupertinoIconButton>[
                  _CupertinoIconButton(
                      direction: 'left', icon: CupertinoIcons.arrow_left, withAdaptives: withAdaptives),
                  _CupertinoIconButton(
                      direction: 'right', icon: CupertinoIcons.arrow_right, withAdaptives: withAdaptives),
                  _CupertinoIconButton(
                      direction: 'down', icon: CupertinoIcons.arrow_down, withAdaptives: withAdaptives),
                  _CupertinoIconButton(direction: 'up', icon: CupertinoIcons.arrow_up, withAdaptives: withAdaptives),
                ]
              : <IconButton>[
                  IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: withAdaptives ? () => _onPressed(direction: 'left') : null),
                  IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: withAdaptives ? () => _onPressed(direction: 'right') : null),
                  IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      onPressed: withAdaptives ? () => _onPressed(direction: 'down') : null),
                  IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: withAdaptives ? () => _onPressed(direction: 'up') : null),
                ],
        ),
      );
}

void _onPressed({@required String direction}) => AdaptiveIcon.preview(direction);

class _CupertinoIconButton extends StatelessWidget {
  const _CupertinoIconButton({@required this.withAdaptives, this.direction, this.icon, Key key}) : super(key: key);

  final bool withAdaptives;
  final String direction;
  final IconData icon;

  @override
  Widget build(BuildContext context) => CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // color: CupertinoColors.activeBlue,
      onPressed: withAdaptives ? () => _onPressed(direction: direction) : null,
      child: Center(child: Icon(icon)));
}
