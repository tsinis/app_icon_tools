import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/user_interface.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color color;
  final bool destructive;

  const AdaptiveButton({Key key, this.text, this.color, this.onPressed, this.destructive = false}) : super(key: key);
  @override
  Widget build(BuildContext context) => Padding(
        padding: destructive ? const EdgeInsets.symmetric(horizontal: 3) : const EdgeInsets.all(8.5),
        child: UserInterface.isApple
            ? CupertinoButton(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: destructive ? 37 : 64),
                color: destructive ? CupertinoColors.destructiveRed : (color ?? CupertinoColors.activeBlue),
                onPressed: onPressed,
                child: Text(text))
            : MaterialButton(
                minWidth: 190,
                colorBrightness: Brightness.dark,
                color: destructive ? Colors.red : (color ?? Colors.blue),
                onPressed: onPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(text.toUpperCase(), style: const TextStyle(letterSpacing: 1.2)),
                ),
              ),
      );
}
