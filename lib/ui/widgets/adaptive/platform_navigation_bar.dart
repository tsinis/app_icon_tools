import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../../models/setup_icon.dart';
import '../../../models/user_interface.dart';
import '../../platform_icons/base_icon.dart';
import '../../platform_icons/platforms_list.dart';

class AdaptiveNavgationBar extends StatelessWidget {
  const AdaptiveNavgationBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int _selectedPlatform = context.select((SetupIcon icon) => icon.platformID);
    final bool _isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: UserInterface.isApple ? 860 : 500),
        child: UserInterface.isApple
            ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CupertinoSlidingSegmentedControl<int>(
                  onValueChanged: context.watch<SetupIcon>().goTo,
                  groupValue: _selectedPlatform,
                  backgroundColor: Colors.amber,
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
                ),
              )
            : GNav(
                onTabChange: context.watch<SetupIcon>().goTo,
                gap: 4,
                tabMargin: const EdgeInsets.only(bottom: 20),
                activeColor: Colors.white,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                tabBackgroundColor: Colors.grey[800],
                selectedIndex: _selectedPlatform,
                tabs: [
                    for (IconPreview platform in platformList)
                      GButton(icon: platform.icon, text: _isSmallScreen ? '' : platform.name),
                  ]),
      ),
    );
  }
}
