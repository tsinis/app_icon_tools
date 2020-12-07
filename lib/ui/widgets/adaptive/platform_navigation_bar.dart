import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:platform_info/platform_info.dart';
import 'package:provider/provider.dart';

import '../../../constants/platforms/platforms_icons_settings.dart';
import '../../../constants/platforms/platforms_list.dart';
import '../../../generated/l10n.dart';
import '../../../models/setup_icon.dart';
import '../../../models/user_interface.dart';

class AdaptiveNavgationBar extends StatelessWidget {
  const AdaptiveNavgationBar();

  @override
  Widget build(BuildContext context) {
    final int selectedPlatform = context.select((SetupIcon icon) => icon.platformID);
    final int countdown = context.select((SetupIcon icon) => icon.countdown);
    final bool isSmallScreen = MediaQuery.of(context).size.width < (UserInterface.isCupertino ? 800 : 600);

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: UserInterface.isCupertino ? 860 : 500),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: (countdown > 0)
              ? _DoneInfo(countdown)
              : UserInterface.isCupertino
                  ? CupertinoSlidingSegmentedControl<int>(
                      onValueChanged: (int selectedPlatform) =>
                          context.read<SetupIcon>().setPlatform(selectedPlatform ?? 0),
                      groupValue: selectedPlatform,
                      backgroundColor: CupertinoTheme.of(context).textTheme.textStyle.color?.withOpacity(0.04) ??
                          CupertinoColors.systemGrey,
                      padding: const EdgeInsets.all(5),
                      children: {
                        for (PlatformIcon platform in platformList)
                          platformList.indexOf(platform): Tooltip(
                              message: '${S.of(context).operatingSystem} ${platform.name}',
                              child: isSmallScreen
                                  ? Icon(platform.icon)
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [Icon(platform.icon), const SizedBox(width: 5), Text(platform.name)]))
                      },
                    )
                  : ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: GNav(
                          onTabChange: (int selectedPlatform) =>
                              context.read<SetupIcon>().setPlatform(selectedPlatform),
                          gap: 0,
                          activeColor: Theme.of(context).sliderTheme.thumbColor,
                          iconSize: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          tabBackgroundColor: Theme.of(context).buttonColor,
                          backgroundColor: Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.04),
                          selectedIndex: selectedPlatform,
                          tabs: [
                            for (PlatformIcon platform in platformList)
                              GButton(
                                  iconColor: Theme.of(context).sliderTheme.thumbColor?.withOpacity(0.6),
                                  semanticLabel: '${S.of(context).operatingSystem} ${platform.name}',
                                  icon: platform.icon,
                                  text: isSmallScreen ? '' : platform.name),
                          ]),
                    ),
        ),
      ),
    );
  }
}

class _DoneInfo extends StatelessWidget {
  const _DoneInfo(this.countdown);

  final int countdown;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Colors.greenAccent.withOpacity(0.2),
            border: Border.all(color: Colors.greenAccent),
            borderRadius: BorderRadius.all(Radius.circular(UserInterface.isCupertino ? 10 : 20))),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UserInterface.isCupertino ? 4 : 8, horizontal: 12),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 10),
                Text(platform.isMobile ? S.of(context).share : S.of(context).downloadsFolder),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                          backgroundColor: Colors.grey.withOpacity(0.25),
                          value: countdown / 100)),
                ),
              ],
            ),
          ),
        ),
      );
}
