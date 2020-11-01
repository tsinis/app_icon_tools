import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../models/user_interface.dart';

class AdaptiveDialog extends StatelessWidget {
  const AdaptiveDialog(
      {this.content,
      this.title,
      this.secondaryButtonTitle,
      this.mainButtonTitle,
      this.onPressedSecondary,
      this.onPressedMain,
      Key key})
      : super(key: key);

  @required
  final Widget content;
  @required
  final String title;
  final String secondaryButtonTitle, mainButtonTitle;
  final void Function() onPressedSecondary, onPressedMain;
  @override
  Widget build(BuildContext context) => UserInterface.isApple
      ? CupertinoAlertDialog(
          title: Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(title)),
          content: content,
          actions: <CupertinoDialogAction>[
            if (onPressedSecondary != null)
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: onPressedSecondary,
                  child: Text(secondaryButtonTitle ?? S.of(context).cancel)),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: onPressedMain,
                textStyle: CupertinoTheme.of(context).textTheme.textStyle,
                child: Text(mainButtonTitle ?? S.of(context).save)),
          ],
        )
      : AlertDialog(
          scrollable: true,
          // titlePadding: const EdgeInsets.all(0),
          // contentPadding: const EdgeInsets.all(0),
          title: Text(title, textAlign: TextAlign.center),
          actions: <TextButton>[
            if (onPressedSecondary != null)
              TextButton(
                  onPressed: onPressedSecondary,
                  child: Text((secondaryButtonTitle ?? S.of(context).cancel).toUpperCase(),
                      style: TextStyle(color: Theme.of(context).errorColor))),
            TextButton(onPressed: onPressedMain, child: Text((mainButtonTitle ?? S.of(context).save).toUpperCase()))
          ],
          content: content);
}
