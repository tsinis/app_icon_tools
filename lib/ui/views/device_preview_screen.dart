import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_hero/local_hero.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../models/setup_icon.dart';
import '../platform_icons/icons_types/apdative_icon.dart';
import '../platform_icons/icons_types/regular_icon.dart';
import '../platform_icons/platforms_list.dart';
import '../widgets/adaptive/platform_navigation_bar.dart';
import '../widgets/adaptive/scaffold_app_bar.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int _selectedPlatform = context.select((SetupIcon icon) => icon.platformID);
    final int _id = platformList[_selectedPlatform].platformID;
    return AdaptiveScaffold(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              child: GestureDetector(
                onTap: context.watch<SetupIcon>().setupScreen,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _SVG(_selectedPlatform),
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
                                        cornerRadius: platformList[_selectedPlatform].cornerRadius,
                                        supportTransparency: _id != 2),
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
          const AdaptiveNavgationBar()
        ],
      ),
    );
  }
}

class _SVG extends StatelessWidget {
  const _SVG(this._selectedPlatform, {Key key}) : super(key: key);

  final int _selectedPlatform;
  String get _svgPath => 'svg/${platformList[_selectedPlatform].name}.svg'.replaceAll(' ', '');

  @override
  Widget build(BuildContext context) =>
      kIsWeb ? WebsafeSvg.asset(_svgPath, height: 640) : SvgPicture.asset('assets/$_svgPath', height: 640);
}