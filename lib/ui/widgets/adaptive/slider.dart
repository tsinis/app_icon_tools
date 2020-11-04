import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/user_interface.dart';

class AdaptiveSlider extends StatelessWidget {
  final double radius;
  final void Function(double) onChanged;
  // final String label;

  const AdaptiveSlider({@required this.radius, @required this.onChanged, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => UserInterface.isApple
      ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: CupertinoSlider(
              value: radius, onChanged: onChanged, min: 0, max: UserInterface.previewIconSize / 2, divisions: 11))
      : Slider(value: radius, onChanged: onChanged, min: 0, max: UserInterface.previewIconSize / 2, divisions: 11);
}
