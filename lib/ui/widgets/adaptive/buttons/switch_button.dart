import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/user_interface.dart';

class AdaptiveSwitch extends StatelessWidget {
  final String title;
  final Function(bool value) onChanged;
  final bool value;

  const AdaptiveSwitch({Key key, this.title, this.onChanged, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) => UserInterface.isApple
      ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(title, textAlign: TextAlign.center),
              // const SizedBox(width: 20),
              CupertinoSwitch(value: value, onChanged: onChanged),
            ],
          ),
        )
      : SwitchListTile(title: Text(title, textAlign: TextAlign.center), value: value, onChanged: onChanged);
}
