import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/user_interface.dart';

class AdaptiveSlider extends StatelessWidget {
  final double value;
  final void Function(double) onChanged;
  // final String label;

  const AdaptiveSlider({Key key, this.value, this.onChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) => UserInterface.isApple
      ? CupertinoSlider(value: value, onChanged: onChanged, min: 0, max: 150, divisions: 11)
      : Slider(value: value, onChanged: onChanged, min: 0, max: 150, divisions: 11);
}
