import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/user_interface.dart';

class AdaptiveSwitch extends StatelessWidget {
  final String title;
  final Function(bool value) onChanged;
  final bool value;

  const AdaptiveSwitch({@required this.title, @required this.onChanged, @required this.value, Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) => UserInterface.isApple
      ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(title, textAlign: TextAlign.center),
              CupertinoSwitch(value: value, onChanged: onChanged),
            ],
          ),
        )
      : SwitchListTile(
          title: Text(title), value: value, onChanged: onChanged, activeColor: Theme.of(context).primaryColorLight);
}
