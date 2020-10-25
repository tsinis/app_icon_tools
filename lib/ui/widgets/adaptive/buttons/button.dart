import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/user_interface.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color color;
  final bool destructive;

  const AdaptiveButton({Key key, this.text, this.color, this.onPressed, this.destructive = false}) : super(key: key);
  @override
  Widget build(BuildContext context) => Padding(
        padding: destructive ? const EdgeInsets.all(0) : const EdgeInsets.all(8.5),
        child: UserInterface.isApple
            ? destructive
                ? Tooltip(
                    message: S.of(context).longPress,
                    child: GestureDetector(
                      onLongPress: onPressed,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Text(text, style: const TextStyle(color: CupertinoColors.destructiveRed)),
                      ),
                    ),
                  )
                : CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 64),
                    color: color ?? CupertinoColors.activeBlue,
                    onPressed: onPressed,
                    child: Text(text))
            : destructive
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Tooltip(
                      message: S.of(context).longPress,
                      child: TextButton(
                          onPressed: () {},
                          onLongPress: onPressed,
                          child: Text(text.toUpperCase(), style: const TextStyle(color: Colors.red))),
                    ))
                : MaterialButton(
                    minWidth: 190,
                    colorBrightness: Brightness.dark,
                    color: color ?? Colors.blue,
                    onPressed: onPressed,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(text.toUpperCase(), style: const TextStyle(letterSpacing: 1.2)),
                    ),
                  ),
      );
}
