import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
// import 'package:provider/provider.dart';

import '../../../../models/user_interface.dart';

class AdaptiveIconButton extends StatelessWidget {
  final Function() onPressed;
  final bool withAdaptiveBackground;

  const AdaptiveIconButton({Key key, this.onPressed, this.withAdaptiveBackground = false}) : super(key: key);
  @override
  Widget build(BuildContext context) => UserInterface.isApple
      ? CupertinoButton(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: withAdaptiveBackground ? 14 : 48),
          color: CupertinoColors.activeBlue,
          onPressed: onPressed,
          child: withAdaptiveBackground
              ? const Center(child: Icon(CupertinoIcons.play_fill, size: 18))
              : Text(S.of(context).testAdaptive))
      : MaterialButton(
          colorBrightness: Brightness.dark,
          color: Colors.blue,
          onPressed: onPressed,
          child: withAdaptiveBackground
              ? const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Icon(Icons.play_arrow, size: 20))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Text(S.of(context).testAdaptive.toUpperCase(), style: const TextStyle(letterSpacing: 1.2)),
                ),
        );
}
