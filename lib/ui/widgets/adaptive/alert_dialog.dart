import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../models/user_interface.dart';

class AdaptiveDialog extends StatelessWidget {
  const AdaptiveDialog(
      {@required this.content,
      @required this.title,
      @required this.onPressedMain,
      this.secondaryButtonTitle,
      this.mainButtonTitle,
      this.onPressedSecondary,
      Key key})
      : super(key: key);

  final Widget content;
  final String title;
  final String secondaryButtonTitle, mainButtonTitle;
  final void Function() onPressedMain;
  final void Function() onPressedSecondary;

  @override
  Widget build(BuildContext context) => UserInterface.isCupertino
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
