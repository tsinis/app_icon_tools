import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/default_non_null_values.dart';
import '../../../models/setup_icon.dart';
import '../transparency_grid.dart';

class RegularIcon extends StatelessWidget {
  const RegularIcon({
    @required this.supportTransparency,
    @required this.cornerRadius,
  });

  final double cornerRadius;
  final bool supportTransparency;

  bool get _onDevice => cornerRadius != NullSafeValues.deviceShape;

  @override
  Widget build(BuildContext context) {
    final Image iconImage = context.select((SetupIcon icon) => icon.iconImage);
    final int selectedPlatformID = context.select((SetupIcon icon) => icon.platformID);
    final Color backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final bool bgColorIsEmpty = context.select((SetupIcon icon) => icon.bgColorIsEmpty);
    final bool webSafeZone = selectedPlatformID == 3;

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(_onDevice ? cornerRadius / 8 : 0)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!_onDevice) const TransparencyGrid(),
          Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: bgColorIsEmpty
                      ? supportTransparency
                          ? Colors.transparent
                          : Colors.black
                      : backgroundColor),
              child: Transform.scale(scale: webSafeZone ? 1.24 : 1, child: iconImage))
        ],
      ),
    );
  }
}
