import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import '../../../../models/user_interface.dart';

class AdaptiveIconButton extends StatelessWidget {
  final Function() onPressed;
  final bool withAdaptiveBackground;

  static const String text = 'Test Adaptive Background';

  const AdaptiveIconButton({Key key, this.onPressed, this.withAdaptiveBackground = false}) : super(key: key);
  @override
  Widget build(BuildContext context) => UserInterface.isApple
      ? CupertinoButton(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: withAdaptiveBackground ? 14 : 58),
          color: CupertinoColors.activeBlue,
          onPressed: onPressed,
          child: withAdaptiveBackground ? const Center(child: Icon(CupertinoIcons.play_fill)) : const Text(text))
      : MaterialButton(
          colorBrightness: Brightness.dark,
          color: Colors.blue,
          onPressed: onPressed,
          child: withAdaptiveBackground
              ? const Padding(padding: EdgeInsets.symmetric(vertical: 7), child: Icon(Icons.play_arrow))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Text(text.toUpperCase(), style: const TextStyle(letterSpacing: 1.2)),
                ),
        );
}
