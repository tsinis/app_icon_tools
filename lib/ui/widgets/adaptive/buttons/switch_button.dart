import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/user_interface.dart';

class AdaptiveSwitch extends StatelessWidget {
  final String text;
  final Function(bool value) onChanged;
  final bool value;

  const AdaptiveSwitch({Key key, this.text, this.onChanged, this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) => UserInterface.isApple
      ? ListTile(
          title: Text(text, textAlign: TextAlign.center), trailing: CupertinoSwitch(value: value, onChanged: onChanged))
      : SwitchListTile(title: Text(text, textAlign: TextAlign.center), value: value, onChanged: onChanged);
}
