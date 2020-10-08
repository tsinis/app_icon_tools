import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:local_hero/local_hero.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../models/setup_icon.dart';
import '../platform_icons/apdative_icon.dart';
import '../platform_icons/platforms_list.dart';
import '../platform_icons/regular_icon.dart';
import '../widgets/adaptive/platform_navigation_bar.dart';
import '../widgets/adaptive/scaffold_app_bar.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _devicePreview = context.select((SetupIcon icon) => icon.devicePreview);
    final int _selectedPlatform = context.select((SetupIcon icon) => icon.platformID);
    final int _id = platformList[_selectedPlatform].platformID;

    return AdaptiveScaffold(
      child: LocalHeroScope(
        duration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        child: Column(
          children: [
            SizedBox(height: _devicePreview ? 20 : 0),
            Expanded(
              child: _devicePreview
                  ? FittedBox(
                      fit: BoxFit.contain,
                      child: GestureDetector(
                        onTap: context.watch<SetupIcon>().changePreview,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            WebsafeSvg.asset(platformList[_selectedPlatform].devicePicture, height: 640),
                            SizedBox(
                              width: (_id == 1 || _id == 2)
                                  ? 105
                                  : (_id > 2)
                                      ? 22
                                      : 40,
                              height: (_id > 2) ? 22 : 40,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: (_id == 1)
                                    ? const AspectRatio(
                                        aspectRatio: 1, child: ClipOval(child: AdaptiveIcon(onDevice: true)))
                                    : RegularIcon(
                                        cornerRadius: platformList[_selectedPlatform].cornerRadius,
                                        supportTransparency: _id != 2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : platformList[_selectedPlatform],
            ),
            const AdaptiveNavgationBar()
          ],
        ),
      ),
    );
  }
}
