import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/platforms/platforms_icons_settings.dart';
import '../../../constants/platforms/platforms_list.dart';
import '../../../models/setup_icon.dart';
import '../../widgets/adaptive/platform_navigation_bar.dart';
import '../../widgets/adaptive/scaffold_and_app_bar.dart';
import '../../widgets/layout.dart';
import 'sections/preview_section.dart';
import 'sections/setup_section.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int platformID = context.select((SetupIcon icon) => icon.platformID);
    final PlatformIcon icon = platformList[platformID];
    final bool haveAdaptiveBg = context.select((SetupIcon icon) => icon.haveAdaptiveBackground);

    // Local size detection.
    final bool isPortrait = (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width) ||
        (MediaQuery.of(context).size.width <= 680);

    return AdaptiveScaffold(
      child: Column(
        children: [
          Expanded(
              child: PreviewLayout(
            portraitOrientation: isPortrait,
            children: [
              PreviewSection(
                canChangeShape: icon.canChangeShape,
                isAdaptive: icon.isAdaptive,
                staticCornerRadius: icon.cornerRadius,
                supportTransparency: icon.supportTransparency,
                haveAdaptiveBg: haveAdaptiveBg,
                pwaIcon: platformID == 3,
              ),
              SetupSection(
                  isAdaptive: icon.isAdaptive,
                  isPortrait: isPortrait,
                  pwaIcon: platformID == 3,
                  haveAdaptiveBg: haveAdaptiveBg)
            ],
          )),
          const AdaptiveNavgationBar()
        ],
      ),
    );
  }
}
