import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../services/platform_detector.dart';

class BrowseButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const BrowseButton({Key key, this.text, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) => CurrentPlatform.isApple
      ? CupertinoButton(color: CupertinoColors.activeBlue, onPressed: onPressed, child: Text(text))
      : MaterialButton(
          colorBrightness: Brightness.dark,
          color: Colors.blue,
          onPressed: onPressed,
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(letterSpacing: 1.2),
          ),
        );
}
