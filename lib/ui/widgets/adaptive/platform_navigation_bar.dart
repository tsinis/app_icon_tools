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
    return UserInterface.isApple
        ? CupertinoSlidingSegmentedControl<int>(
            onValueChanged: context.watch<SetupIcon>().goTo,
            children: {},
          )
        : OverflowBox(
            alignment: Alignment.bottomCenter,
            maxWidth: 500,
            child: GNav(
                onTabChange: context.watch<SetupIcon>().goTo,
                gap: 4,
                tabMargin: const EdgeInsets.only(bottom: 10),
                activeColor: Colors.white,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                tabBackgroundColor: Colors.grey[800],
                selectedIndex: _selectedPlatform,
                tabs: [
                  for (IconPreview platform in platformList)
                    GButton(icon: platform.icon, text: _isSmallScreen ? '' : platform.name),
                ]),
          );
  }
}
