import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/user_interface.dart';

class AdaptiveDialog extends StatelessWidget {
  const AdaptiveDialog(
      {this.content, this.title, this.leftButton, this.rightButton, this.onPressedLeft, this.onPressedRight, Key key})
      : super(key: key);

  @required
  final Widget content;
  @required
  final String title, leftButton, rightButton;
  final void Function() onPressedLeft, onPressedRight;
  @override
  Widget build(BuildContext context) => UserInterface.isApple
      ? CupertinoAlertDialog(
          //TODO: Check PR fix on Color Picker.
          title: Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(title)),
          content: content,
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(isDestructiveAction: true, onPressed: onPressedLeft, child: Text(leftButton)),
            CupertinoDialogAction(isDefaultAction: true, onPressed: onPressedRight, child: Text(rightButton)),
          ],
        )
      : AlertDialog(
          // titlePadding: const EdgeInsets.all(0),
          // contentPadding: const EdgeInsets.all(0),
          title: Text(title, textAlign: TextAlign.center),
          actions: <TextButton>[
            TextButton(
                onPressed: onPressedLeft,
                child: Text(leftButton.toUpperCase(), style: const TextStyle(color: Colors.red))),
            TextButton(onPressed: onPressedRight, child: Text(rightButton.toUpperCase()))
          ],
          content: content);
}
