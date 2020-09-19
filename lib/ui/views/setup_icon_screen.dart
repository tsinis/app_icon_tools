import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:local_hero/local_hero.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../models/setup_icon.dart';
import '../platform_icons/icon.dart';
import '../platform_icons/platforms_list.dart';
import '../widgets/adaptive/platform_navigation_bar.dart';
import '../widgets/adaptive/scaffold_app_bar.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _devicePreview = context.select((SetupIcon icon) => icon.devicePreview);
    final int _selectedPlatform = context.select((SetupIcon icon) => icon.platformID);
    final int id = platformList[_selectedPlatform].platformID;

    return AdaptiveScaffold(
        child: GestureDetector(
      onTap: context.watch<SetupIcon>().changePreview,
      child: LocalHeroScope(
        duration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: _devicePreview
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        WebsafeSvg.asset(platformList[_selectedPlatform].devicePicture, height: 640),
                        SizedBox(
                          height: (id > 2) ? 21 : 40,
                          width: (id == 1 || id == 2)
                              ? 105
                              : (id > 2)
                                  ? 21
                                  : 40,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconWithShape(
                              onDevice: true,
                              supportTransparency: id != 2,
                              adaptiveIcon: id == 1,
                            ),
                          ),
                        ),
                      ],
                    )
                  : platformList[_selectedPlatform],
            ),
            const AdaptiveNavgationBar()
          ],
        ),
      ),
    ));
  }
}
