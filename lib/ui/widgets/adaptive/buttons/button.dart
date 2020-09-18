import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import '../../../../models/user_interface.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color color;
  final bool destructive;

  const AdaptiveButton({Key key, this.text, this.color, this.onPressed, this.destructive = false}) : super(key: key);
  @override
  Widget build(BuildContext context) => Padding(
        padding: destructive ? const EdgeInsets.symmetric(horizontal: 12) : const EdgeInsets.all(12),
        child: UserInterface.isApple
            ? CupertinoButton(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: destructive ? 37 : 64),
                color: destructive ? CupertinoColors.destructiveRed : (color ?? CupertinoColors.activeBlue),
                onPressed: onPressed,
                child: Text(text))
            : MaterialButton(
                colorBrightness: Brightness.dark,
                color: destructive ? Colors.red : (color ?? Colors.blue),
                onPressed: onPressed,
                child: Text(
                  text.toUpperCase(),
                  style: const TextStyle(letterSpacing: 1.2),
                ),
              ),
      );
}
