import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/user_interface.dart';

class AdaptiveSwitch extends StatelessWidget {
  const AdaptiveSwitch({
    @required this.title,
    @required this.onChanged,
    @required this.value,
    this.toRestart = false,
    Key key,
  }) : super(key: key);

  final String title;
  final bool value, toRestart;

  final Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) => UserInterface.isCupertino
      ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, textAlign: TextAlign.center),
            CupertinoSwitch(
                value: value,
                onChanged: onChanged,
                activeColor: toRestart ? Colors.pink[300] : CupertinoColors.systemGreen)
          ]))
      : SwitchListTile(
          title: Text(title),
          value: value,
          onChanged: onChanged,
          activeColor: toRestart ? Colors.pink[300] : Theme.of(context).primaryColorLight);
}
