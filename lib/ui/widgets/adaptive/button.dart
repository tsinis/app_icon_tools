import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import '../../../models/user_interface.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const AdaptiveButton({Key key, this.text, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(12),
        child: UserInterface.isApple
            ? CupertinoButton(color: CupertinoColors.activeBlue, onPressed: onPressed, child: Text(text))
            : MaterialButton(
                colorBrightness: Brightness.dark,
                color: Colors.blue,
                onPressed: onPressed,
                child: Text(
                  text.toUpperCase(),
                  style: const TextStyle(letterSpacing: 1.2),
                ),
              ),
      );
}
