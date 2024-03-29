import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/user_interface.dart';
import '../../icons/apdative_icon.dart';

class AdaptiveIconButtons extends StatelessWidget {
  const AdaptiveIconButtons({this.withAdaptives = false});

  final bool withAdaptives;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: withAdaptives ? S.of(context).parallax : S.of(context).noBackground,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: UserInterface.isCupertino
              ? <_CupertinoIconButton>[
                  _CupertinoIconButton(
                      direction: AdaptiveIcon.moveLeft, icon: CupertinoIcons.arrow_left, withAdaptives: withAdaptives),
                  _CupertinoIconButton(
                      direction: AdaptiveIcon.moveRight,
                      icon: CupertinoIcons.arrow_right,
                      withAdaptives: withAdaptives),
                  _CupertinoIconButton(
                      direction: AdaptiveIcon.moveDown, icon: CupertinoIcons.arrow_down, withAdaptives: withAdaptives),
                  _CupertinoIconButton(
                      direction: AdaptiveIcon.moveUp, icon: CupertinoIcons.arrow_up, withAdaptives: withAdaptives),
                ]
              : <IconButton>[
                  IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: withAdaptives ? () => _onPressed(direction: AdaptiveIcon.moveLeft) : null),
                  IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: withAdaptives ? () => _onPressed(direction: AdaptiveIcon.moveRight) : null),
                  IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      onPressed: withAdaptives ? () => _onPressed(direction: AdaptiveIcon.moveDown) : null),
                  IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: withAdaptives ? () => _onPressed(direction: AdaptiveIcon.moveUp) : null),
                ],
        ),
      );
}

void _onPressed({@required String direction}) => AdaptiveIcon.preview(direction);
// void _onPressed({@required String direction, @required bool withAdaptives}) {
//   if (withAdaptives) {
//     AdaptiveIcon.preview(direction);
//   }
// }

class _CupertinoIconButton extends StatelessWidget {
  const _CupertinoIconButton({
    @required this.withAdaptives,
    @required this.direction,
    @required this.icon,
  });

  final String direction;
  final IconData icon;
  final bool withAdaptives;

  @override
  Widget build(BuildContext context) => CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      onPressed: withAdaptives ? () => _onPressed(direction: direction) : null,
      child: Center(
          child: Icon(icon,
              color: withAdaptives
                  ? CupertinoTheme.of(context).primaryContrastingColor
                  : CupertinoTheme.of(context).primaryColor)));
}
