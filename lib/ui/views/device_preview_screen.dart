import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_hero/local_hero.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../constants/platforms_list.dart';
import '../../generated/l10n.dart';
import '../../models/setup_icon.dart';
import '../platform_icons/icons_types/apdative_icon.dart';
import '../platform_icons/icons_types/regular_icon.dart';
import '../widgets/adaptive/platform_navigation_bar.dart';
import '../widgets/adaptive/scaffold_app_bar.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int selectedPlatform = context.select((SetupIcon icon) => icon.platformID);
    final int platformID = platformList[selectedPlatform].platformID;

    return AdaptiveScaffold(
      deviceScreen: true,
      child: Column(
        children: [
          const SizedBox(height: 60),
          Expanded(
            child: InteractiveViewer(
              maxScale: 2,
              child: FittedBox(
                child: GestureDetector(
                  onTap: () => context.read<SetupIcon>().setupScreen(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _SVG(selectedPlatform),
                      SizedBox(
                        width: (platformID == 1 || platformID == 2)
                            ? 105
                            : (platformID > 2)
                                ? (platformID == 3)
                                    ? 36
                                    : 22
                                : 40,
                        height: (platformID > 2)
                            ? (platformID == 3)
                                ? 36
                                : 22
                            : 40,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: (platformID == 1)
                              ? const AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipOval(child: Hero(tag: 'adaptive', child: AdaptiveIcon(onDevice: true))))
                              : Hero(
                                  tag: 'regular',
                                  child: LocalHeroScope(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.elasticOut,
                                    child: LocalHero(
                                      tag: 'local',
                                      child: RegularIcon(
                                          cornerRadius: platformList[selectedPlatform].cornerRadius,
                                          supportTransparency: platformID != 2),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const AdaptiveNavgationBar()
        ],
      ),
    );
  }
}

class _SVG extends StatelessWidget {
  const _SVG(this.selectedPlatform, {Key key}) : super(key: key);

  final int selectedPlatform;
  String get _platformName => platformList[selectedPlatform].name;
  String get _svgPath => 'svg/$_platformName.svg'.replaceAll(' ', '');

  @override
  Widget build(BuildContext context) => Tooltip(
      waitDuration: const Duration(seconds: 2),
      showDuration: const Duration(seconds: 2),
      message: S.of(context).lookOnDevice(_platformName),
      child: kIsWeb ? WebsafeSvg.asset(_svgPath, height: 640) : SvgPicture.asset('assets/$_svgPath', height: 640));
}
