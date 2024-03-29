import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/user_interface.dart';

class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    @required this.text,
    @required this.onPressed,
    this.color,
    this.isDestructive = false,
    this.isDisabled = false,
  });

  final String text;
  final Function() onPressed;
  final Color color;
  final bool isDestructive, isDisabled;

  @override
  Widget build(BuildContext context) => Padding(
        padding: isDestructive ? const EdgeInsets.all(0) : const EdgeInsets.all(8.5),
        child: UserInterface.isCupertino
            ? isDestructive
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
                    color: color ?? context.select((UserInterface ui) => ui.materialTheme.accentColor),
                    onPressed: isDisabled ? null : onPressed,
                    child: Text(text,
                        style: TextStyle(
                            color: (CupertinoTheme.of(context).brightness == Brightness.dark)
                                ? CupertinoColors.white
                                : CupertinoColors.black)))
            : isDestructive
                ? Tooltip(
                    message: S.of(context).longPress,
                    child: TextButton(
                      onPressed: () {},
                      onLongPress: onPressed,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(text.toUpperCase(), style: TextStyle(color: Theme.of(context).errorColor)),
                      ),
                    ),
                  )
                : MaterialButton(
                    colorBrightness: Brightness.dark,
                    minWidth: 190,
                    color: color ?? Theme.of(context).accentColor,
                    onPressed: isDisabled ? null : onPressed,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(text.toUpperCase(), style: const TextStyle(letterSpacing: 1.2)),
                    ),
                  ),
      );
}
