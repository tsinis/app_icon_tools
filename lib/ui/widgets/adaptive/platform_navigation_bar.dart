import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../../models/setup_icon.dart';
import '../../../models/user_interface.dart';
import '../../platform_icons/icons_screen.dart';
import '../../platform_icons/platforms_list.dart';

class AdaptiveNavgationBar extends StatelessWidget {
  const AdaptiveNavgationBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int _selectedPlatform = context.select((SetupIcon icon) => icon.platformID);
    final int _countDown = context.select((SetupIcon icon) => icon.countDown);
    final bool _isSmallScreen = MediaQuery.of(context).size.width < (UserInterface.isApple ? 800 : 600);
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: UserInterface.isApple ? 860 : 500),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: (_countDown > 0)
              ? _DoneInfo(_countDown)
              : UserInterface.isApple
                  ? CupertinoSlidingSegmentedControl<int>(
                      onValueChanged: context.watch<SetupIcon>().setPlatform,
                      groupValue: _selectedPlatform,
                      backgroundColor: CupertinoTheme.of(context).textTheme.textStyle.color?.withOpacity(0.04),
                      padding: const EdgeInsets.all(5),
                      children: {
                        for (IconPreview platform in platformList)
                          platformList.indexOf(platform): _isSmallScreen
                              ? Icon(platform.icon)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [Icon(platform.icon), const SizedBox(width: 5), Text(platform.name)])
                      },
                    )
                  : ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: GNav(
                          onTabChange: context.watch<SetupIcon>().setPlatform,
                          gap: 4,
                          activeColor: Theme.of(context).sliderTheme.thumbColor,
                          iconSize: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          tabBackgroundColor: Theme.of(context).buttonColor,
                          backgroundColor: Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.04),
                          selectedIndex: _selectedPlatform,
                          tabs: [
                            for (IconPreview platform in platformList)
                              GButton(
                                  iconColor: Theme.of(context).sliderTheme.thumbColor?.withOpacity(0.6),
                                  // margin: const EdgeInsets.all(6),
                                  icon: platform.icon,
                                  text: _isSmallScreen ? '' : platform.name),
                          ]),
                    ),
        ),
      ),
    );
  }
}

class _DoneInfo extends StatelessWidget {
  const _DoneInfo(this._countDown, {Key key}) : super(key: key);

  final int _countDown;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Colors.greenAccent.withOpacity(0.2),
            border: Border.all(color: Colors.greenAccent),
            borderRadius: BorderRadius.all(Radius.circular(UserInterface.isApple ? 10 : 20))),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UserInterface.isApple ? 4 : 1, horizontal: 12),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 10),
                const Text('Done! "icons.zip" is in "Downloads" folder.'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Transform.scale(
                      scale: 0.6,
                      child: CircularProgressIndicator(
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                          backgroundColor: Colors.grey.withOpacity(0.25),
                          value: _countDown / 100)),
                ),
              ],
            ),
          ),
        ),
      );
}
