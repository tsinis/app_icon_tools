import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../models/user_interface.dart';

class AdaptiveDialog extends StatelessWidget {
  const AdaptiveDialog(
      {this.content, this.title, this.leftButton, this.rightButton, this.onPressedLeft, this.onPressedRight, Key key})
      : super(key: key);
  //TODO! Add function to save the Settings
  @required
  final Widget content;
  @required
  final String title;
  final String leftButton, rightButton;
  final void Function() onPressedLeft, onPressedRight;
  @override
  Widget build(BuildContext context) => UserInterface.isApple
      ? CupertinoAlertDialog(
          title: Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(title)),
          content: content,
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
                isDestructiveAction: true, onPressed: onPressedLeft, child: Text(leftButton ?? S.of(context).cancel)),
            CupertinoDialogAction(
                isDefaultAction: true, onPressed: onPressedRight, child: Text(rightButton ?? S.of(context).save)),
          ],
        )
      : AlertDialog(
          scrollable: true,
          // titlePadding: const EdgeInsets.all(0),
          // contentPadding: const EdgeInsets.all(0),
          title: Text(title, textAlign: TextAlign.center),
          actions: <TextButton>[
            TextButton(
                onPressed: onPressedLeft,
                child: Text((leftButton ?? S.of(context).cancel).toUpperCase(),
                    style: const TextStyle(color: Colors.red))),
            TextButton(onPressed: onPressedRight, child: Text((rightButton ?? S.of(context).save).toUpperCase()))
          ],
          content: content);
}
