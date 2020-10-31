import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../models/user_interface.dart';

class AdaptiveDialog extends StatelessWidget {
  const AdaptiveDialog(
      {this.content,
      this.title,
      this.leftButtonTitle,
      this.rightButtonTitle,
      this.onPressedLeft,
      this.onPressedRight,
      Key key})
      : super(key: key);

  @required
  final Widget content;
  @required
  final String title;
  final String leftButtonTitle, rightButtonTitle;
  final void Function() onPressedLeft, onPressedRight;
  @override
  Widget build(BuildContext context) => UserInterface.isApple
      ? CupertinoAlertDialog(
          title: Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(title)),
          content: content,
          actions: <CupertinoDialogAction>[
            if (onPressedLeft != null)
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: onPressedLeft,
                  child: Text(leftButtonTitle ?? S.of(context).cancel)),
            CupertinoDialogAction(
                isDefaultAction: true, onPressed: onPressedRight, child: Text(rightButtonTitle ?? S.of(context).save)),
          ],
        )
      : AlertDialog(
          scrollable: true,
          // titlePadding: const EdgeInsets.all(0),
          // contentPadding: const EdgeInsets.all(0),
          title: Text(title, textAlign: TextAlign.center),
          actions: <TextButton>[
            if (onPressedLeft != null)
              TextButton(
                  onPressed: onPressedLeft,
                  child: Text((leftButtonTitle ?? S.of(context).cancel).toUpperCase(),
                      style: const TextStyle(color: Colors.red))),
            TextButton(onPressed: onPressedRight, child: Text((rightButtonTitle ?? S.of(context).save).toUpperCase()))
          ],
          content: content);
}
